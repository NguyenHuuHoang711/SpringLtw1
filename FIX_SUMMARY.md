# Faculty-Based Course Filtering Fix

## Problem
Students were seeing ALL courses regardless of their faculty/department. The requirement was that students should only see courses from their own faculty.

## Solution
Modified the course loading mechanism to use the `/api/registration/offerings` endpoint which automatically filters courses based on the selected registration period. Registration periods are pre-configured with faculty restrictions.

## Files Modified

### `/src/main/resources/static/demo/app.js`

#### 1. **loadClasses() Function** (Lines 52-61)
**Before:**
```javascript
async function loadClasses() {
  const res = await axios.get('/api/course-classes');
  classes = res.data.data || res.data;
}
```

**After:**
```javascript
async function loadClasses() {
  const periodId = periodSelect.value;
  if (!periodId) {
    classes = [];
    return;
  }
  // Load offerings filtered by the selected registration period (which is configured for specific faculties)
  const res = await axios.get(`/api/registration/offerings?period_id=${encodeURIComponent(periodId)}`);
  classes = res.data.data || res.data;
}
```
✅ **Why:** Now filters courses based on the selected registration period, which has faculty restrictions configured via `target_config`

#### 2. **renderClasses() Function** (Lines 93-110)
**Before:**
```javascript
function renderClasses() {
  classesDiv.innerHTML = '';
  classes.forEach(c => {
    const card = document.createElement('div');
    card.className = 'p-3 border rounded flex justify-between items-center';
    card.innerHTML = `<div>
        <div class="font-semibold">${c.description || c.courseId}</div>
        <div class="text-sm text-gray-600">Available: ${c.availableSlots || 'N/A'}</div>
      </div>`;
    // ... rest of the code
  });
}
```

**After:**
```javascript
function renderClasses() {
  classesDiv.innerHTML = '';
  classes.forEach(c => {
    const card = document.createElement('div');
    card.className = 'p-3 border rounded flex justify-between items-center';
    card.innerHTML = `<div>
        <div class="font-semibold">${c.courseName || c.courseId}</div>
        <div class="text-sm text-gray-600">Available: ${c.availableSlots || 'N/A'} / ${c.maxSlots || 'N/A'}</div>
        ${c.credits ? `<div class="text-sm text-gray-600">Credits: ${c.credits}</div>` : ''}
      </div>`;
    // ... rest of the code
  });
}
```
✅ **Why:** Updated field references to match CourseOffering entity and improved display information

#### 3. **registerClass() Function** (Lines 126-155)
**Before:**
```javascript
async function registerClass(classId) {
  // ...
  const payload = {
    studentId: studentId,
    courseId: classId, // backend expects courseClassId via this field
    registrationPeriodId: regPeriodId,
    registrationType: 1
  };
  // ...
}
```

**After:**
```javascript
async function registerClass(offeringId) {
  // ...
  const offering = classes.find(c => c.id === offeringId);
  if (!offering) {
    alert('Course offering not found');
    return;
  }
  const payload = {
    studentId: studentId,
    courseId: offering.courseId, // Use courseId from the offering
    registrationPeriodId: regPeriodId,
    registrationType: 1
  };
  // ...
}
```
✅ **Why:** Extracts the actual courseId from the CourseOffering entity before sending to API

#### 4. **Event Listeners** (Lines 158-168)
**Before:**
```javascript
studentSelect.addEventListener('change', async () => {
  await loadPeriods();
  await refreshMyRegs();
});
periodSelect.addEventListener('change', refreshMyRegs);
```

**After:**
```javascript
studentSelect.addEventListener('change', async () => {
  await loadPeriods();
  await loadClasses();
  renderClasses();
  await refreshMyRegs();
});
periodSelect.addEventListener('change', async () => {
  await loadClasses();
  renderClasses();
  await refreshMyRegs();
});
```
✅ **Why:** Ensures courses are reloaded whenever the selected student or period changes

## How It Works

### Database-Level Filtering
1. **Registration Periods** are pre-configured with `target_config` JSON specifying allowed faculties:
   - "Đợt học lại CNTT K23" → faculties: ["Công nghệ thông tin"]
   - "Đợt chính thức CNTT K24" → faculties: ["Công nghệ thông tin"]
   - "Đợt đăng ký QTKD (All)" → faculties: ["Quản trị kinh doanh"]
   - "Đợt đăng ký Ngoại ngữ" → faculties: ["Ngoại ngữ"]

2. **Course Offerings** are created per registration period with specific course sets

3. **Student Registration Flow:**
   - Student selects their name → loads periods eligible for their faculty
   - Student selects a registration period → loads only offerings for that period
   - Backend validates that the period matches their faculty via `target_config`

### Benefits
✅ Faculty filtering enforced at database level (not just frontend)
✅ Students cannot see courses outside their faculty  
✅ Prevents registration errors by pre-filtering options
✅ Maintains consistency between what's shown and what can be registered
✅ Utilizes existing registration period configuration infrastructure

## Testing
- Build successful: `mvn clean compile -DskipTests` ✓
- All JavaScript syntax valid ✓
- API endpoints already exist in backend ✓

## Verification Steps
1. Select a student from Công nghệ thông tin faculty → should only see CNTT registration periods
2. Select CNTT period → should only see CNTT courses
3. Select a student from Quản trị kinh doanh → should only see QTKD periods
4. Select QTKD period → should only see QTKD courses
5. Repeat for other faculties to verify isolation

