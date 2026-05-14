package com.example.demo.modules.registration.service;

import com.example.demo.exception.BadRequestException;
import com.example.demo.exception.ConflictException;
import com.example.demo.exception.NotFoundException;
import com.example.demo.modules.course.entity.Course;
import com.example.demo.modules.department.repository.DepartmentRepository;
import com.example.demo.modules.grade.repository.GradeRepository;
import com.example.demo.modules.registration.entity.CourseRegistration;
import com.example.demo.modules.registration.entity.RegistrationPeriod;
import com.example.demo.modules.registration.mapper.CourseRegistrationMapper;
import com.example.demo.modules.registration.mapper.RegistrationPeriodMapper;
import com.example.demo.modules.registration.repository.CourseRegistrationRepository;
import com.example.demo.modules.course.repository.CourseRepository;
import com.example.demo.modules.course.repository.EquivalentCourseRepository;
import com.example.demo.modules.grade.entity.Grade;
import com.example.demo.modules.registration.repository.RegistrationPeriodRepository;
import com.example.demo.modules.registration.request.CourseRegistrationRequest;
import com.example.demo.modules.registration.response.CourseRegistrationResponse;
import com.example.demo.modules.registration.response.FocusCourseResponse;
import com.example.demo.modules.student.entity.StudentProfile;
import com.example.demo.modules.student.repository.StudentProfileRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class RegistrationServiceImplTest {

    @Mock
    private RegistrationPeriodRepository registrationPeriodRepository;
    @Mock
    private CourseRegistrationRepository courseRegistrationRepository;
    @Mock
    private EquivalentCourseRepository equivalentCourseRepository;
    @Mock
    private CourseRepository courseRepository;
    @Mock
    private DepartmentRepository departmentRepository;
    @Mock
    private GradeRepository gradeRepository;
    private final RegistrationPeriodMapper registrationPeriodMapper = new RegistrationPeriodMapper();
    @Mock
    private CourseRegistrationMapper courseRegistrationMapper;
    @Mock
    private StudentProfileRepository studentProfileRepository;
    @Mock
    private ObjectMapper objectMapper;

    private RegistrationServiceImpl registrationService;

    private UUID studentId;
    private UUID courseId;
    private UUID registrationPeriodId;
    private CourseRegistrationRequest request;
    private RegistrationPeriod activePeriod;
    private Course course;
    private StudentProfile profile;

    @BeforeEach
    void setUp() {
        studentId = UUID.randomUUID();
        courseId = UUID.randomUUID();
        registrationPeriodId = UUID.randomUUID();

        request = new CourseRegistrationRequest();
        request.setStudentId(studentId);
        request.setCourseId(courseId);
        request.setRegistrationPeriodId(registrationPeriodId);
        request.setRegistrationType(1);

        activePeriod = new RegistrationPeriod();
        activePeriod.setId(registrationPeriodId);
        activePeriod.setIsActive(true);
        activePeriod.setStartTime(LocalDateTime.now().minusDays(1));
        activePeriod.setEndTime(LocalDateTime.now().plusDays(1));
        activePeriod.setMaxCredits(20);

        course = new Course();
        course.setId(courseId);
        course.setCode("IT101");
        course.setCredits(new BigDecimal("3.0"));

        profile = new StudentProfile();
        profile.setStudentId(studentId);
        profile.setStudentCode("SV_IT23_A1");
        profile.setFaculty("Công nghệ thông tin");
        profile.setCohort("K23");
        profile.setMajor("Kỹ thuật phần mềm");

        lenient().when(studentProfileRepository.findByStudentId(studentId)).thenReturn(Optional.of(profile));

        registrationService = new RegistrationServiceImpl(
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
    }

    @Test
    void registerCourse_Success() {
        // Arrange
        when(registrationPeriodRepository.findById(registrationPeriodId)).thenReturn(Optional.of(activePeriod));
        when(courseRegistrationRepository.findByStudentIdAndCourseClassIdAndRegistrationPeriodId(studentId, courseId, registrationPeriodId))
                .thenReturn(Optional.empty());
        when(courseRepository.findById(courseId)).thenReturn(Optional.of(course));
        
        // Mock current credits and equivalent courses
        when(courseRegistrationRepository.findByStudentIdAndRegistrationPeriodId(studentId, registrationPeriodId))
                .thenReturn(Collections.emptyList());
        when(equivalentCourseRepository.findReplacedCourses(courseId)).thenReturn(new java.util.ArrayList<>());
        when(equivalentCourseRepository.findReplacingCourses(courseId)).thenReturn(new java.util.ArrayList<>());

        CourseRegistration entity = new CourseRegistration();
        when(courseRegistrationMapper.toEntity(request)).thenReturn(entity);
        when(courseRegistrationRepository.save(any(CourseRegistration.class))).thenReturn(entity);
        
        CourseRegistrationResponse response = new CourseRegistrationResponse();
        when(courseRegistrationMapper.toResponse(entity)).thenReturn(response);

        // Act
        CourseRegistrationResponse result = registrationService.registerCourse(request);

        // Assert
        assertNotNull(result);
        verify(courseRegistrationRepository, times(1)).save(any(CourseRegistration.class));
    }

    @Test
    void registerCourse_PeriodNotFound_ThrowsNotFoundException() {
        // Arrange
        when(registrationPeriodRepository.findById(registrationPeriodId)).thenReturn(Optional.empty());

        // Act & Assert
        assertThrows(NotFoundException.class, () -> registrationService.registerCourse(request));
    }

    @Test
    void registerCourse_PeriodNotActive_ThrowsBadRequestException() {
        // Arrange
        activePeriod.setIsActive(false);
        when(registrationPeriodRepository.findById(registrationPeriodId)).thenReturn(Optional.of(activePeriod));

        // Act & Assert
        assertThrows(BadRequestException.class, () -> registrationService.registerCourse(request));
    }

    @Test
    void registerCourse_DuplicateRegistration_ThrowsConflictException() {
        // Arrange
        when(registrationPeriodRepository.findById(registrationPeriodId)).thenReturn(Optional.of(activePeriod));
        when(courseRepository.findById(courseId)).thenReturn(Optional.of(course));
        when(courseRegistrationRepository.findByStudentIdAndCourseClassIdAndRegistrationPeriodId(studentId, courseId, registrationPeriodId))
                .thenReturn(Optional.of(new CourseRegistration()));

        // Act & Assert
        assertThrows(ConflictException.class, () -> registrationService.registerCourse(request));
    }

    @Test
    void getFocusCourses_ReturnsFailedAndImprovementCourses_ByBestGrade() {
        UUID failedCourseId = UUID.randomUUID();
        UUID improveCourseId = UUID.randomUUID();
        UUID completedCourseId = UUID.randomUUID();

        Grade failed1 = new Grade();
        failed1.setStudentId(studentId);
        failed1.setCourseId(failedCourseId);
        failed1.setGrade(3.0);

        Grade failed2 = new Grade();
        failed2.setStudentId(studentId);
        failed2.setCourseId(failedCourseId);
        failed2.setGrade(2.5);

        Grade improve = new Grade();
        improve.setStudentId(studentId);
        improve.setCourseId(improveCourseId);
        improve.setGrade(5.5);

        Grade completedLow = new Grade();
        completedLow.setStudentId(studentId);
        completedLow.setCourseId(completedCourseId);
        completedLow.setGrade(3.0);

        Grade completedHigh = new Grade();
        completedHigh.setStudentId(studentId);
        completedHigh.setCourseId(completedCourseId);
        completedHigh.setGrade(7.0);

        when(gradeRepository.findByStudentId(studentId)).thenReturn(java.util.List.of(failed1, failed2, improve, completedLow, completedHigh));

        Course failedCourse = Course.builder().id(failedCourseId).code("IT201").name("Data Structures").credits(BigDecimal.valueOf(3)).build();
        Course improveCourse = Course.builder().id(improveCourseId).code("IT202").name("Java Programming").credits(BigDecimal.valueOf(3)).build();
        Course completedCourse = Course.builder().id(completedCourseId).code("IT203").name("Operating Systems").credits(BigDecimal.valueOf(3)).build();
        when(courseRepository.findAllById(any())).thenReturn(java.util.List.of(failedCourse, improveCourse, completedCourse));

        java.util.List<FocusCourseResponse> result = registrationService.getFocusCourses(studentId);

        assertEquals(2, result.size());
        assertEquals("FAILED", result.get(0).getStatus());
        assertEquals(failedCourseId, result.get(0).getCourseId());
        assertEquals(3.0, result.get(0).getBestGrade());
        assertEquals("IMPROVEMENT", result.get(1).getStatus());
        assertEquals(improveCourseId, result.get(1).getCourseId());
    }

    @Test
    void getEligibleRegistrationPeriods_FiltersByStudentProfile() throws Exception {
        // Arrange
        String allowedConfig = "{\"faculties\":[\"Công nghệ thông tin\"],\"cohorts\":[\"K23\"]}";
        String deniedConfig = "{\"faculties\":[\"Quản trị kinh doanh\"],\"cohorts\":[\"K24\"]}";

        RegistrationPeriod allowed = new RegistrationPeriod();
        allowed.setId(UUID.randomUUID());
        allowed.setIsActive(true);
        allowed.setStartTime(LocalDateTime.now().minusDays(1));
        allowed.setEndTime(LocalDateTime.now().plusDays(1));
        allowed.setTargetConfig(allowedConfig);

        RegistrationPeriod denied = new RegistrationPeriod();
        denied.setId(UUID.randomUUID());
        denied.setIsActive(true);
        denied.setStartTime(LocalDateTime.now().minusDays(1));
        denied.setEndTime(LocalDateTime.now().plusDays(1));
        denied.setTargetConfig(deniedConfig);

        when(registrationPeriodRepository.findByIsActiveTrue()).thenReturn(java.util.List.of(allowed, denied));
        when(objectMapper.readTree(allowedConfig)).thenReturn(new ObjectMapper().readTree(allowedConfig));
        when(objectMapper.readTree(deniedConfig)).thenReturn(new ObjectMapper().readTree(deniedConfig));

        // Act
        java.util.List<com.example.demo.modules.registration.response.RegistrationPeriodResponse> periods = registrationService.getEligibleRegistrationPeriods(studentId);

        // Assert
        assertEquals(1, periods.size());
        assertEquals(allowed.getId(), periods.get(0).getId());
    }

    @Test
    void getEligibleRegistrationPeriods_MalformedConfig_IsRejected() throws Exception {
        // Arrange
        String badConfig = "{not-json";
        RegistrationPeriod broken = new RegistrationPeriod();
        broken.setId(UUID.randomUUID());
        broken.setIsActive(true);
        broken.setStartTime(LocalDateTime.now().minusDays(1));
        broken.setEndTime(LocalDateTime.now().plusDays(1));
        broken.setTargetConfig(badConfig);

        when(registrationPeriodRepository.findByIsActiveTrue()).thenReturn(java.util.List.of(broken));
        when(objectMapper.readTree(badConfig)).thenThrow(new RuntimeException("bad json"));

        // Act
        java.util.List<com.example.demo.modules.registration.response.RegistrationPeriodResponse> periods = registrationService.getEligibleRegistrationPeriods(studentId);

        // Assert
        assertTrue(periods.isEmpty());
    }

    @Test
    void registerCourse_StudentNotEligibleForPeriod_ThrowsBadRequestException() throws Exception {
        // Arrange
        activePeriod.setTargetConfig("{\"faculties\":[\"Quản trị kinh doanh\"],\"cohorts\":[\"K24\"]}");
        when(registrationPeriodRepository.findById(registrationPeriodId)).thenReturn(Optional.of(activePeriod));
        when(courseRepository.findById(courseId)).thenReturn(Optional.of(course));
        when(objectMapper.readTree(activePeriod.getTargetConfig())).thenReturn(new ObjectMapper().readTree(activePeriod.getTargetConfig()));

        // Act & Assert
        BadRequestException exception = assertThrows(BadRequestException.class, () -> registrationService.registerCourse(request));
        assertTrue(exception.getMessage().contains("not eligible"));
    }

    @Test
    void registerCourse_CourseOutsideFaculty_ThrowsBadRequestException() {
        // Arrange
        Course otherFacultyCourse = new Course();
        otherFacultyCourse.setId(courseId);
        otherFacultyCourse.setCode("BA101");
        otherFacultyCourse.setCredits(new BigDecimal("3.0"));

        when(registrationPeriodRepository.findById(registrationPeriodId)).thenReturn(Optional.of(activePeriod));
        when(courseRepository.findById(courseId)).thenReturn(Optional.of(otherFacultyCourse));

        // Act & Assert
        BadRequestException exception = assertThrows(BadRequestException.class, () -> registrationService.registerCourse(request));
        assertTrue(exception.getMessage().contains("outside their faculty"));
    }

    @Test
    void registerCourse_MaxCreditsExceeded_ThrowsBadRequestException() {
        // Arrange
        activePeriod.setMaxCredits(5);
        when(registrationPeriodRepository.findById(registrationPeriodId)).thenReturn(Optional.of(activePeriod));
        when(courseRegistrationRepository.findByStudentIdAndCourseClassIdAndRegistrationPeriodId(studentId, courseId, registrationPeriodId))
                .thenReturn(Optional.empty());
        
        Course expensiveCourse = new Course();
        expensiveCourse.setId(courseId);
        expensiveCourse.setCredits(new BigDecimal("6.0")); // Exceeds max 5
        when(courseRepository.findById(courseId)).thenReturn(Optional.of(expensiveCourse));
        
        when(courseRegistrationRepository.findByStudentIdAndRegistrationPeriodId(studentId, registrationPeriodId))
                .thenReturn(Collections.emptyList());
        when(equivalentCourseRepository.findReplacedCourses(courseId)).thenReturn(new java.util.ArrayList<>());
        when(equivalentCourseRepository.findReplacingCourses(courseId)).thenReturn(new java.util.ArrayList<>());

        // Act & Assert
        BadRequestException exception = assertThrows(BadRequestException.class, () -> registrationService.registerCourse(request));
        assertTrue(exception.getMessage().contains("Exceeds maximum allowed credits"));
    }

    @Test
    void cancelRegistration_Success() {
        // Arrange
        UUID registrationId = UUID.randomUUID();
        CourseRegistration existingRegistration = new CourseRegistration();
        existingRegistration.setId(registrationId);
        existingRegistration.setStudentId(studentId);
        existingRegistration.setIsPaid(false);
        existingRegistration.setStatus(1);

        when(courseRegistrationRepository.findById(registrationId)).thenReturn(Optional.of(existingRegistration));
        when(courseRegistrationRepository.save(any(CourseRegistration.class))).thenReturn(existingRegistration);
        
        CourseRegistrationResponse expectedResponse = new CourseRegistrationResponse();
        when(courseRegistrationMapper.toResponse(existingRegistration)).thenReturn(expectedResponse);

        // Act
        CourseRegistrationResponse result = registrationService.cancelRegistration(registrationId, studentId);

        // Assert
        assertNotNull(result);
        assertEquals(3, existingRegistration.getStatus()); // Status changed to 3 (Cancel)
        verify(courseRegistrationRepository, times(1)).save(existingRegistration);
    }
    
    @Test
    void cancelRegistration_AlreadyPaid_ThrowsBadRequestException() {
        // Arrange
        UUID registrationId = UUID.randomUUID();
        CourseRegistration existingRegistration = new CourseRegistration();
        existingRegistration.setId(registrationId);
        existingRegistration.setStudentId(studentId);
        existingRegistration.setIsPaid(true); // Already paid
        
        when(courseRegistrationRepository.findById(registrationId)).thenReturn(Optional.of(existingRegistration));

        // Act & Assert
        assertThrows(BadRequestException.class, () -> registrationService.cancelRegistration(registrationId, studentId));
    }
}