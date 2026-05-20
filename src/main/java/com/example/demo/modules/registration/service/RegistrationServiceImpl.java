package com.example.demo.modules.registration.service;

import com.example.demo.exception.BadRequestException;
import com.example.demo.exception.ConflictException;
import com.example.demo.exception.NotFoundException;
import com.example.demo.modules.course.entity.Course;
import com.example.demo.modules.department.entity.Department;
import com.example.demo.modules.department.repository.DepartmentRepository;
import com.example.demo.modules.grade.entity.Grade;
import com.example.demo.modules.grade.repository.GradeRepository;
import com.example.demo.modules.registration.entity.CourseRegistration;
import com.example.demo.modules.registration.entity.RegistrationPeriod;
import com.example.demo.modules.registration.mapper.CourseRegistrationMapper;
import com.example.demo.modules.registration.mapper.RegistrationPeriodMapper;
import com.example.demo.modules.course.repository.CourseRepository;
import com.example.demo.modules.registration.repository.CourseRegistrationRepository;
import com.example.demo.modules.course.repository.EquivalentCourseRepository;
import com.example.demo.modules.registration.repository.RegistrationPeriodRepository;
import com.example.demo.modules.student.entity.StudentProfile;
import com.example.demo.modules.student.repository.StudentProfileRepository;
import com.example.demo.modules.registration.request.CourseRegistrationRequest;
import com.example.demo.modules.registration.response.CourseRegistrationResponse;
import com.example.demo.modules.registration.response.FocusCourseResponse;
import com.example.demo.modules.registration.response.RegistrationPeriodResponse;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Comparator;
import java.text.Normalizer;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class RegistrationServiceImpl implements RegistrationService {

    private final RegistrationPeriodRepository registrationPeriodRepository;
    private final CourseRegistrationRepository courseRegistrationRepository;
    private final EquivalentCourseRepository equivalentCourseRepository;
    private final CourseRepository courseRepository;
    private final DepartmentRepository departmentRepository;
    private final GradeRepository gradeRepository;
    private final RegistrationPeriodMapper registrationPeriodMapper;
    private final CourseRegistrationMapper courseRegistrationMapper;
    private final StudentProfileRepository studentProfileRepository;
    private final ObjectMapper objectMapper;

    @Override
    public List<RegistrationPeriodResponse> getActiveRegistrationPeriods() {
        // Changed findByIsActiveTrueAndIsOpenTrue to findByIsActiveTrue
        // since isOpen doesn't exist in the new RegistrationPeriod entity
        return registrationPeriodRepository.findByIsActiveTrue().stream()
                .map(registrationPeriodMapper::toResponse)
                .collect(Collectors.toList());
    }

    @Override
    public List<RegistrationPeriodResponse> getEligibleRegistrationPeriods(UUID studentId) {
        StudentProfile profile = studentProfileRepository.findByStudentId(studentId).orElse(null);
        return registrationPeriodRepository.findByIsActiveTrue().stream()
                .filter(this::isWithinTimeWindow)
                .filter(period -> matchesStudentTarget(period, profile))
                .map(registrationPeriodMapper::toResponse)
                .collect(Collectors.toList());
    }

    @Override
    public List<CourseRegistrationResponse> getMyRegistrations(UUID studentId) {
        return courseRegistrationRepository.findByStudentId(studentId).stream()
                .map(courseRegistrationMapper::toResponse)
                .collect(Collectors.toList());
    }

    @Override
    public List<FocusCourseResponse> getFocusCourses(UUID studentId) {
        List<Grade> grades = gradeRepository.findByStudentId(studentId);
        if (grades == null || grades.isEmpty()) {
            return List.of();
        }

        Map<UUID, Double> bestGradesByCourse = new HashMap<>();
        for (Grade grade : grades) {
            if (grade == null || grade.getCourseId() == null || grade.getGrade() == null) continue;
            bestGradesByCourse.merge(grade.getCourseId(), grade.getGrade(), Math::max);
        }

        if (bestGradesByCourse.isEmpty()) {
            return List.of();
        }

        Map<UUID, Course> coursesById = courseRepository.findAllById(bestGradesByCourse.keySet())
                .stream()
                .collect(Collectors.toMap(Course::getId, course -> course));

        Map<UUID, FocusCourseResponse> focusMap = new LinkedHashMap<>();
        for (Map.Entry<UUID, Double> entry : bestGradesByCourse.entrySet()) {
            Double bestGrade = entry.getValue();
            if (bestGrade == null || bestGrade >= 6.5) {
                continue;
            }

            Course course = coursesById.get(entry.getKey());
            if (course == null) {
                continue;
            }

            FocusCourseResponse response = new FocusCourseResponse();
            response.setCourseId(course.getId());
            response.setCourseCode(course.getCode());
            response.setCourseName(course.getName());
            response.setCredits(course.getCredits() != null ? course.getCredits().doubleValue() : null);
            response.setBestGrade(bestGrade);
            response.setStatus(bestGrade < 4.0 ? "FAILED" : "IMPROVEMENT");
            focusMap.put(course.getId(), response);
        }

        return focusMap.values().stream()
                .sorted(Comparator
                        .comparing((FocusCourseResponse r) -> "FAILED".equals(r.getStatus()) ? 0 : 1)
                        .thenComparing(FocusCourseResponse::getBestGrade)
                        .thenComparing(FocusCourseResponse::getCourseName, Comparator.nullsLast(String::compareToIgnoreCase)))
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public CourseRegistrationResponse registerCourse(CourseRegistrationRequest request) {
        RegistrationPeriod period = validateRegistrationPeriod(request.getRegistrationPeriodId(), request.isForce());

        Course course = courseRepository.findById(request.getCourseId())
                .orElseThrow(() -> new NotFoundException("Course not found"));

        if (!request.isForce()) {
            StudentProfile profile = studentProfileRepository.findByStudentId(request.getStudentId())
                    .orElseThrow(() -> new NotFoundException("Student profile not found"));

            validateStudentEligibility(period, profile);
            validateCourseEligibility(course, profile);
        }

        // Pass request.getCourseId() which will be checked against courseClassId in the DB
        validateDuplicateRegistration(request.getStudentId(), request.getCourseId(), request.getRegistrationPeriodId());

        if (!request.isForce()) {
            validateEquivalentCourses(request.getStudentId(), course.getId(), request.getRegistrationPeriodId());
            validateCredits(request.getStudentId(), course.getCredits(), period.getMaxCredits(), request.getRegistrationPeriodId());
        }

        CourseRegistration registration = courseRegistrationMapper.toEntity(request);
        CourseRegistration savedRegistration = courseRegistrationRepository.save(registration);

        return courseRegistrationMapper.toResponse(savedRegistration);
    }

    @Override
    @Transactional
    public CourseRegistrationResponse cancelRegistration(UUID registrationId, UUID studentId) {
        CourseRegistration registration = courseRegistrationRepository.findById(registrationId)
                .orElseThrow(() -> new NotFoundException("Registration not found"));

        if (!registration.getStudentId().equals(studentId)) {
            throw new BadRequestException("You are not authorized to cancel this registration");
        }

        if (registration.getIsPaid()) {
            throw new BadRequestException("Cannot cancel a paid registration");
        }

        registration.setStatus(3); // 3=cancel
        CourseRegistration updatedRegistration = courseRegistrationRepository.save(registration);
        return courseRegistrationMapper.toResponse(updatedRegistration);
    }

    @Override
    @Transactional
    public CourseRegistrationResponse reactivateRegistration(UUID registrationId, UUID studentId) {
        CourseRegistration registration = courseRegistrationRepository.findById(registrationId)
                .orElseThrow(() -> new NotFoundException("Registration not found"));

        if (!registration.getStudentId().equals(studentId)) {
            throw new BadRequestException("You are not authorized to reactivate this registration");
        }

        if (registration.getStatus() != 3) {
            throw new BadRequestException("Only cancelled registrations can be reactivated");
        }

        registration.setStatus(1); // 1=active
        CourseRegistration updatedRegistration = courseRegistrationRepository.save(registration);
        return courseRegistrationMapper.toResponse(updatedRegistration);
    }

    private RegistrationPeriod validateRegistrationPeriod(UUID periodId, boolean force) {
        RegistrationPeriod period = registrationPeriodRepository.findById(periodId)
                .orElseThrow(() -> new NotFoundException("Registration period not found"));

        if (force) return period;

        // Removed check for period.getIsOpen() since it doesn't exist in the entity
        if (!period.getIsActive()) {
            throw new BadRequestException("Registration period is not active");
        }

        LocalDateTime now = LocalDateTime.now();
        if (now.isBefore(period.getStartTime()) || now.isAfter(period.getEndTime())) {
            throw new BadRequestException("Registration is not within the allowed time frame");
        }
        return period;
    }

    private boolean isWithinTimeWindow(RegistrationPeriod period) {
        LocalDateTime now = LocalDateTime.now();
        return !now.isBefore(period.getStartTime()) && !now.isAfter(period.getEndTime());
    }

    private boolean matchesStudentTarget(RegistrationPeriod period, StudentProfile profile) {
        if (profile == null) return false;
        if (period.getTargetConfig() == null || period.getTargetConfig().isBlank()) return true;

        try {
            JsonNode config = objectMapper.readTree(period.getTargetConfig());
            return matchesAny(config.get("faculties"), profile.getFaculty())
                    && matchesAny(config.get("cohorts"), profile.getCohort())
                    && matchesAny(config.get("majors"), profile.getMajor());
        } catch (Exception ex) {
            return false;
        }
    }

    private void validateStudentEligibility(RegistrationPeriod period, StudentProfile profile) {
        if (!matchesStudentTarget(period, profile)) {
            throw new BadRequestException("Student is not eligible for this registration period");
        }
    }

    private void validateCourseEligibility(Course course, StudentProfile profile) {
        if (!isCourseAlignedWithStudentFaculty(course, profile)) {
            throw new BadRequestException("Student cannot register for courses outside their faculty");
        }
    }

    private boolean isCourseAlignedWithStudentFaculty(Course course, StudentProfile profile) {
        if (course == null || profile == null) return false;

        if (course.getDepartmentId() != null) {
            return departmentRepository.findById(course.getDepartmentId())
                    .map(department -> facultyMatches(profile.getFaculty(), department))
                    .orElse(false);
        }

        return facultyMatchesCourseCode(profile.getFaculty(), course.getCode());
    }

    private boolean facultyMatches(String faculty, Department department) {
        if (department == null) return false;
        return facultyMatchesLabel(faculty, department.getName())
                || facultyMatchesLabel(faculty, department.getCode());
    }

    private boolean facultyMatchesCourseCode(String faculty, String courseCode) {
        if (courseCode == null || courseCode.isBlank()) {
            return true;
        }

        String normalizedCode = normalize(courseCode);
        if (normalizedCode.startsWith("it")) {
            return facultyMatchesLabel(faculty, "Công nghệ thông tin");
        }
        if (normalizedCode.startsWith("ba")) {
            return facultyMatchesLabel(faculty, "Quản trị kinh doanh");
        }
        if (normalizedCode.startsWith("en")) {
            return facultyMatchesLabel(faculty, "Ngoại ngữ");
        }
        return true;
    }

    private boolean facultyMatchesLabel(String faculty, String candidate) {
        if (faculty == null || candidate == null) return false;

        String normalizedFaculty = normalize(faculty);
        String normalizedCandidate = normalize(candidate);
        Set<String> aliases = facultyAliases(normalizedFaculty);
        return aliases.contains(normalizedCandidate) || normalizedFaculty.equals(normalizedCandidate);
    }

    private Set<String> facultyAliases(String normalizedFaculty) {
        if (normalizedFaculty.contains("congnghethongtin") || normalizedFaculty.equals("cntt") || normalizedFaculty.equals("it")) {
            return Set.of("congnghethongtin", "cntt", "it");
        }
        if (normalizedFaculty.contains("quantrikinhdoanh") || normalizedFaculty.equals("qtkd") || normalizedFaculty.equals("ba")) {
            return Set.of("quantrikinhdoanh", "qtkd", "ba");
        }
        if (normalizedFaculty.contains("ngoaingu") || normalizedFaculty.equals("en") || normalizedFaculty.equals("nn")) {
            return Set.of("ngoaingu", "en", "nn");
        }
        return Collections.singleton(normalizedFaculty);
    }

    private String normalize(String input) {
        if (input == null) return "";
        String normalized = Normalizer.normalize(input, Normalizer.Form.NFD).replaceAll("\\p{M}", "");
        return normalized.toLowerCase(Locale.ROOT).replaceAll("[^a-z0-9]+", "");
    }

    private boolean matchesAny(JsonNode node, String value) {
        if (node == null || node.isNull() || node.isEmpty()) return true;
        if (value == null) return false;

        if (node.isArray()) {
            for (JsonNode item : node) {
                if (value.equalsIgnoreCase(item.asText())) {
                    return true;
                }
            }
            return false;
        }

        return value.equalsIgnoreCase(node.asText());
    }

    private void validateDuplicateRegistration(UUID studentId, UUID courseId, UUID registrationPeriodId) {
        // Calls the method that maps courseId to the courseClassId field
        courseRegistrationRepository.findByStudentIdAndCourseClassIdAndRegistrationPeriodId(studentId, courseId, registrationPeriodId)
                .ifPresent(r -> {
                    throw new ConflictException("You have already registered for this course");
                });
    }

    private void validateEquivalentCourses(UUID studentId, UUID newCourseId, UUID registrationPeriodId) {
        List<UUID> registeredCourseIds = getRegisteredCourseIds(studentId, registrationPeriodId);
        List<UUID> equivalentCourses = equivalentCourseRepository.findReplacedCourses(newCourseId);
        equivalentCourses.addAll(equivalentCourseRepository.findReplacingCourses(newCourseId));

        for (UUID registeredCourseId : registeredCourseIds) {
            if (equivalentCourses.contains(registeredCourseId)) {
                throw new ConflictException("You cannot register for an equivalent course that replaces a course you are already registered for.");
            }
        }
    }

    private void validateCredits(UUID studentId, BigDecimal newCourseCredits, int maxCredits, UUID registrationPeriodId) {
        BigDecimal currentCredits = getCurrentCredits(studentId, registrationPeriodId);
        if (currentCredits.add(newCourseCredits).compareTo(BigDecimal.valueOf(maxCredits)) > 0) {
            throw new BadRequestException("Exceeds maximum allowed credits (" + maxCredits + ")");
        }
    }

    private List<UUID> getRegisteredCourseIds(UUID studentId, UUID registrationPeriodId) {
        List<CourseRegistration> registrations = courseRegistrationRepository.findByStudentIdAndRegistrationPeriodId(studentId, registrationPeriodId);
        // Extracts the courseClassId from the entity (which we treat as courseId logically)
        return registrations.stream().map(CourseRegistration::getCourseClassId).collect(Collectors.toList());
    }

    private BigDecimal getCurrentCredits(UUID studentId, UUID registrationPeriodId) {
        List<CourseRegistration> registrations = courseRegistrationRepository.findByStudentIdAndRegistrationPeriodId(studentId, registrationPeriodId);
        // Extracts the courseClassId to look up the course
        List<UUID> courseIds = registrations.stream().map(CourseRegistration::getCourseClassId).collect(Collectors.toList());
        List<Course> courses = courseRepository.findAllById(courseIds);
        return courses.stream()
                .map(Course::getCredits)
                .filter(java.util.Objects::nonNull)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
}