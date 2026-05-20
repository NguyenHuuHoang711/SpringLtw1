# Test Re-register Button Fix

## Issue Fixed
The re-register button ("Đăng ký lại") was not working properly. The main issues were:
1. Inline onclick parameters could be unreliable if data contained special characters
2. Error messages weren't always properly displayed to the user
3. Parameter parsing could fail silently

## Changes Made
1. **Improved Button Generation** - Changed from inline onclick to using data attributes
   - Before: `onclick="registerCourse('${o.courseId}', ${existingReg.registrationType}, '${existingReg.id}')"`
   - After: `onclick="handleReactivate(this)"` with data attributes for safe parameter passing

2. **New Handler Function** - Added `handleReactivate(button)` function that:
   - Safely extracts parameters from data attributes
   - Validates all required parameters before proceeding
   - Provides detailed error messages if parameters are invalid
   - Logs errors to browser console for debugging

3. **Better Error Handling** - Added try-catch blocks with:
   - Proper error display to user
   - Console logging for debugging
   - Validation of API response structure

## How to Test

### Step 1: Open Browser DevTools
1. Open http://localhost:8080
2. Login as a student (fake login with studentId)
3. Press F12 to open Developer Tools
4. Go to Console tab to see any error messages

### Step 2: Create Test Data (Manual)
1. Go to "Đợt đăng ký" section
2. Select a registration period
3. Find a course and click "Đăng ký" to register
4. The course should appear in "Môn học đã đăng ký" section
5. In the same offerings view, click the "Hủy ĐK" button to cancel the registration

### Step 3: Test Re-register Button
1. The cancelled course should now show "ĐK Lại" button instead of "Hủy ĐK"
2. Click the "ĐK Lại" button
3. You should see "Đăng ký thành công!" alert
4. The course status should change back to "Thành công"
5. The button should change back to "Hủy ĐK"

### Step 4: Check for Errors
If the button doesn't work:
1. Check the Console tab for any error messages
2. Check the Network tab to see if the PATCH request to `/api/registration/{id}/reactivate` is being made
3. Look for response errors from the API
4. Common issues:
   - Status is not 3 (not cancelled) - check "Môn học đã đăng ký" section
   - API returns 404 - check if registration ID is correct
   - API returns 400 - check if student ID matches

### Step 5: Verify Console Output
If there are issues, console logs will show:
```
Missing data attributes: { courseId, regId, regTypeStr }
Invalid regType: <value>
Registration error: <error message>
```

## Expected Behavior

### Successful Re-registration Flow
```
User cancels registration (status: 1 → 3)
                    ↓
"Hủy ĐK" button changes to "ĐK Lại" button
                    ↓
User clicks "ĐK Lại" button
                    ↓
handleReactivate() extracts parameters from data attributes
                    ↓
registerCourse() is called with registrationId (triggers PATCH)
                    ↓
Backend: reactivateRegistration() changes status back to 1
                    ↓
Success alert shown, UI refreshed
                    ↓
"ĐK Lại" button changes back to "Hủy ĐK" button
```

## Backend Endpoint
The re-register feature uses:
- **Endpoint**: `PATCH /api/registration/{id}/reactivate?student_id={uuid}`
- **Validation**: Only cancelled registrations (status=3) can be reactivated
- **Response**: Returns updated CourseRegistrationResponse with status=1

## Browser Debugging Tips
1. Set breakpoint in DevTools at the `handleReactivate` function
2. Inspect the button element to see data attributes
3. Check Network tab for PATCH request details
4. Use Console to log parameter values: `console.log({courseId, regId, regType})`

## Rollback
If you need to rollback these changes, the key modifications are in:
- `src/main/resources/templates/student.html` - function `handleReactivate()` and button generation
- No backend changes required

