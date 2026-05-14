
package com.example.demo.modules.registration.service;

import com.example.demo.exception.NotFoundException;
import com.example.demo.modules.course.entity.EquivalentCourse;
import com.example.demo.modules.registration.entity.RegistrationPeriod;
import com.example.demo.modules.registration.mapper.EquivalentCourseMapper;
import com.example.demo.modules.registration.mapper.RegistrationPeriodMapper;
import com.example.demo.modules.registration.repository.CourseRegistrationRepository;
import com.example.demo.modules.course.repository.EquivalentCourseRepository;
import com.example.demo.modules.registration.repository.RegistrationPeriodRepository;
import com.example.demo.modules.registration.request.EquivalentCourseRequest;
import com.example.demo.modules.registration.request.RegistrationPeriodRequest;
import com.example.demo.modules.registration.response.CourseRegistrationResponse;
import com.example.demo.modules.registration.response.EquivalentCourseResponse;
import com.example.demo.modules.registration.response.RegistrationPeriodResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AdminRegistrationServiceImpl implements AdminRegistrationService {

    private final RegistrationPeriodRepository registrationPeriodRepository;
    private final EquivalentCourseRepository equivalentCourseRepository;
    private final CourseRegistrationRepository courseRegistrationRepository;
    private final RegistrationPeriodMapper registrationPeriodMapper;
    private final EquivalentCourseMapper equivalentCourseMapper;
    private final com.example.demo.modules.registration.mapper.CourseRegistrationMapper courseRegistrationMapper;


    @Override
    @Transactional
    public RegistrationPeriodResponse createRegistrationPeriod(RegistrationPeriodRequest request) {
        RegistrationPeriod period = registrationPeriodMapper.toEntity(request);
        RegistrationPeriod savedPeriod = registrationPeriodRepository.save(period);
        return registrationPeriodMapper.toResponse(savedPeriod);
    }

    @Override
    @Transactional
    public RegistrationPeriodResponse updateRegistrationPeriod(UUID id, RegistrationPeriodRequest request) {
        RegistrationPeriod period = registrationPeriodRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Registration period not found"));
        registrationPeriodMapper.updateEntity(period, request);
        RegistrationPeriod updatedPeriod = registrationPeriodRepository.save(period);
        return registrationPeriodMapper.toResponse(updatedPeriod);
    }

    @Override
    @Transactional
    public void deleteRegistrationPeriod(UUID id) {
        if (!registrationPeriodRepository.existsById(id)) {
            throw new NotFoundException("Registration period not found");
        }
        registrationPeriodRepository.deleteById(id);
    }

    @Override
    public List<RegistrationPeriodResponse> getAllRegistrationPeriods() {
        return registrationPeriodRepository.findAll().stream()
                .map(registrationPeriodMapper::toResponse)
                .collect(Collectors.toList());
    }

    @Override
    public RegistrationPeriodResponse getRegistrationPeriodById(UUID id) {
        return registrationPeriodRepository.findById(id)
                .map(registrationPeriodMapper::toResponse)
                .orElseThrow(() -> new NotFoundException("Registration period not found"));
    }

    @Override
    @Transactional
    public EquivalentCourseResponse createEquivalentCourse(EquivalentCourseRequest request) {
        EquivalentCourse equivalentCourse = equivalentCourseMapper.toEntity(request);
        EquivalentCourse savedEquivalentCourse = equivalentCourseRepository.save(equivalentCourse);
        return equivalentCourseMapper.toResponse(savedEquivalentCourse);
    }

    @Override
    @Transactional
    public EquivalentCourseResponse updateEquivalentCourse(UUID id, EquivalentCourseRequest request) {
        EquivalentCourse equivalentCourse = equivalentCourseRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Equivalent course not found"));
        equivalentCourseMapper.updateEntity(equivalentCourse, request);
        EquivalentCourse updatedEquivalentCourse = equivalentCourseRepository.save(equivalentCourse);
        return equivalentCourseMapper.toResponse(updatedEquivalentCourse);
    }

    @Override
    @Transactional
    public void deleteEquivalentCourse(UUID id) {
        if (!equivalentCourseRepository.existsById(id)) {
            throw new NotFoundException("Equivalent course not found");
        }
        equivalentCourseRepository.deleteById(id);
    }

    @Override
    public List<EquivalentCourseResponse> getAllEquivalentCourses() {
        return equivalentCourseRepository.findAll().stream()
                .map(equivalentCourseMapper::toResponse)
                .collect(Collectors.toList());
    }

    @Override
    public EquivalentCourseResponse getEquivalentCourseById(UUID id) {
        return equivalentCourseRepository.findById(id)
                .map(equivalentCourseMapper::toResponse)
                .orElseThrow(() -> new NotFoundException("Equivalent course not found"));
    }

    @Override
    public List<CourseRegistrationResponse> getAllCourseRegistrations() {
        return courseRegistrationRepository.findAll().stream()
                .map(courseRegistrationMapper::toResponse)
                .collect(Collectors.toList());
    }
}
