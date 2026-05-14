package com.example.demo.tests;

import com.example.demo.exception.ConflictException;
import com.example.demo.modules.course.entity.Course;
import com.example.demo.modules.registration.entity.CourseRegistration;
import com.example.demo.modules.registration.entity.RegistrationPeriod;
import com.example.demo.modules.registration.mapper.CourseRegistrationMapper;
import com.example.demo.modules.registration.mapper.RegistrationPeriodMapper;
import com.example.demo.modules.department.repository.DepartmentRepository;
import com.example.demo.modules.grade.repository.GradeRepository;
import com.example.demo.modules.registration.repository.CourseRegistrationRepository;
import com.example.demo.modules.registration.repository.RegistrationPeriodRepository;
import com.example.demo.modules.course.repository.EquivalentCourseRepository;
import com.example.demo.modules.course.repository.CourseRepository;
import com.example.demo.modules.registration.request.CourseRegistrationRequest;
import com.example.demo.modules.registration.response.CourseRegistrationResponse;
import com.example.demo.modules.registration.service.RegistrationServiceImpl;
import com.example.demo.modules.student.entity.StudentProfile;
import com.example.demo.modules.student.repository.StudentProfileRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.type.TypeReference;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import org.junit.jupiter.api.extension.ExtendWith;

import java.io.File;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;
import java.nio.file.Files;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class RegistrationFlowTest {

    @Mock
    RegistrationPeriodRepository registrationPeriodRepository;

    @Mock
    CourseRegistrationRepository courseRegistrationRepository;

    @Mock
    EquivalentCourseRepository equivalentCourseRepository;

    @Mock
    CourseRepository courseRepository;

    @Mock
    DepartmentRepository departmentRepository;

    @Mock
    GradeRepository gradeRepository;

    @Mock
    StudentProfileRepository studentProfileRepository;

    // Use real mappers
    CourseRegistrationMapper courseRegistrationMapper = new CourseRegistrationMapper();
    RegistrationPeriodMapper registrationPeriodMapper = new RegistrationPeriodMapper();
    ObjectMapper objectMapper = new ObjectMapper();

    @Test
    public void registrationFlows_writeResultFile() throws Exception {
        // Prepare service with mocks
        RegistrationServiceImpl service = new RegistrationServiceImpl(
                registrationPeriodRepository,
                courseRegistrationRepository,
                equivalentCourseRepository,
                courseRepository,
                departmentRepository,
                gradeRepository,
                registrationPeriodMapper,
                courseRegistrationMapper,
                studentProfileRepository,
                objectMapper
        );

        // IDs
        UUID regPeriodId = UUID.randomUUID();
        UUID studentA = UUID.randomUUID();
        UUID courseClass1 = UUID.randomUUID();
        UUID courseClass2 = UUID.randomUUID();

        StudentProfile profile = new StudentProfile();
        profile.setStudentId(studentA);
        profile.setStudentCode("SV_IT23_A1");
        profile.setFaculty("Công nghệ thông tin");
        profile.setCohort("K23");
        profile.setMajor("Kỹ thuật phần mềm");
        when(studentProfileRepository.findByStudentId(eq(studentA))).thenReturn(Optional.of(profile));

        // Registration period active now
        RegistrationPeriod period = RegistrationPeriod.builder()
                .id(regPeriodId)
                .name("Test Period")
                .startTime(LocalDateTime.now().minusDays(1))
                .endTime(LocalDateTime.now().plusDays(1))
                .isActive(true)
                .maxCredits(25)
                .build();

        when(registrationPeriodRepository.findById(eq(regPeriodId))).thenReturn(Optional.of(period));

        // Course exists (credits 3)
        Course course1 = Course.builder().id(courseClass1).code("IT101").credits(BigDecimal.valueOf(3)).build();
        when(courseRepository.findById(eq(courseClass1))).thenReturn(Optional.of(course1));

        // No equivalents
        when(equivalentCourseRepository.findReplacedCourses(eq(courseClass1))).thenReturn(new ArrayList<>());
        when(equivalentCourseRepository.findReplacingCourses(eq(courseClass1))).thenReturn(new ArrayList<>());

        // No existing registration => should succeed
        when(courseRegistrationRepository.findByStudentIdAndCourseClassIdAndRegistrationPeriodId(eq(studentA), eq(courseClass1), eq(regPeriodId)))
                .thenReturn(Optional.empty());

        // Save will return the same entity with generated id
        when(courseRegistrationRepository.save(any(CourseRegistration.class))).thenAnswer(invocation -> {
            CourseRegistration r = invocation.getArgument(0);
            r.setId(UUID.randomUUID());
            return r;
        });

        // Perform registration (success)
        CourseRegistrationRequest req1 = new CourseRegistrationRequest();
        req1.setStudentId(studentA);
        req1.setCourseId(courseClass1);
        req1.setRegistrationPeriodId(regPeriodId);
        req1.setRegistrationType(1);

        CourseRegistrationResponse resp1 = service.registerCourse(req1);

        assertNotNull(resp1);
        Map<String, Object> results = new LinkedHashMap<>();
        results.put("register_success_id", resp1.getId().toString());

        // Duplicate registration scenario => should throw ConflictException
        when(courseRegistrationRepository.findByStudentIdAndCourseClassIdAndRegistrationPeriodId(eq(studentA), eq(courseClass2), eq(regPeriodId)))
                .thenReturn(Optional.of(new CourseRegistration()));

        Course course2 = Course.builder().id(courseClass2).code("IT102").credits(BigDecimal.valueOf(3)).build();
        when(courseRepository.findById(eq(courseClass2))).thenReturn(Optional.of(course2));

        CourseRegistrationRequest reqDup = new CourseRegistrationRequest();
        reqDup.setStudentId(studentA);
        reqDup.setCourseId(courseClass2);
        reqDup.setRegistrationPeriodId(regPeriodId);
        reqDup.setRegistrationType(1);

        String dupMessage = null;
        try {
            service.registerCourse(reqDup);
        } catch (ConflictException ex) {
            dupMessage = ex.getMessage();
        }
        results.put("register_duplicate_message", dupMessage == null ? "none" : dupMessage);

        // Cancel registration: prepare an existing registration saved earlier
        UUID existingRegId = UUID.randomUUID();
        CourseRegistration existing = CourseRegistration.builder()
                .id(existingRegId)
                .studentId(studentA)
                .courseClassId(courseClass1)
                .registrationPeriodId(regPeriodId)
                .isPaid(false)
                .status(1)
                .build();

        when(courseRegistrationRepository.findById(eq(existingRegId))).thenReturn(Optional.of(existing));
        when(courseRegistrationRepository.save(any(CourseRegistration.class))).thenAnswer(invocation -> invocation.getArgument(0));

        CourseRegistrationResponse cancelled = service.cancelRegistration(existingRegId, studentA);
        results.put("cancelled_registration_id", cancelled.getId().toString());
        results.put("cancelled_status", cancelled.getStatus());

        // Write results to a deterministic file so the assistant / developer can read it after tests
        File outDir = new File("target/test-results");
        Files.createDirectories(outDir.toPath());
        File out = new File(outDir, "registration-demo-result.json");
        objectMapper.writerWithDefaultPrettyPrinter().writeValue(out, results);

        // Also assert file exists and contains keys
        assertTrue(out.exists());
        Map<String, Object> readBack = objectMapper.readValue(out, new TypeReference<>() {});
        assertTrue(readBack.containsKey("register_success_id"));
        assertTrue(readBack.containsKey("register_duplicate_message"));
        assertTrue(readBack.containsKey("cancelled_registration_id"));
    }
}

