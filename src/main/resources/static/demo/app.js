const studentSelect = document.getElementById('studentSelect');
const academicSelect = document.getElementById('academicSelect');
const periodSelect = document.getElementById('periodSelect');
const classesDiv = document.getElementById('classes');
const myRegsDiv = document.getElementById('myRegs');

let students = [];
let academics = [];
let periods = [];
let classes = [];

async function init() {
  await loadStudents();
  renderStudents();
  await loadAcademicYears();
  await loadPeriods();
  renderAcademicYears();
}

async function loadStudents() {
  const res = await axios.get('/api/student-profiles');
  const data = res.data.data || res.data;
  students = (data || []).map(s => ({
    id: s.studentId,
    name: s.studentName,
    email: s.email
  }));
}

async function loadAcademicYears() {
  const res = await axios.get('/api/academic-years');
  academics = res.data.data || res.data; // ApiResponse wrapper sometimes used
}

async function loadPeriods() {
  const studentId = studentSelect.value;
  const url = studentId
    ? `/api/registration/periods/active?student_id=${encodeURIComponent(studentId)}`
    : '/api/registration/periods/active';
  const res = await axios.get(url);
  periods = res.data.data || res.data;
  renderPeriods();

  if (periods.length > 0) {
    const current = periodSelect.value;
    const stillValid = periods.some(p => p.id === current);
    if (!current || !stillValid) {
      periodSelect.value = periods[0].id;
    }
  } else {
    periodSelect.innerHTML = '<option value="">No eligible periods</option>';
  }

  await loadClasses();
  renderClasses();
}

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

function renderStudents() {
  studentSelect.innerHTML = '';
  students.forEach(s => {
    const opt = document.createElement('option');
    opt.value = s.id;
    opt.text = s.name + ' (' + s.email + ')';
    studentSelect.appendChild(opt);
  });
}

function renderAcademicYears() {
  academicSelect.innerHTML = '';
  academics.forEach(a => {
    const opt = document.createElement('option');
    opt.value = a.id;
    opt.text = a.name + ' - ' + a.code;
    academicSelect.appendChild(opt);
  });
}

function renderPeriods() {
  periodSelect.innerHTML = '';
  periods.forEach(p => {
    const opt = document.createElement('option');
    opt.value = p.id;
    opt.text = p.name;
    periodSelect.appendChild(opt);
  });
}

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
    const btn = document.createElement('button');
    btn.className = 'bg-blue-600 text-white px-3 py-1 rounded';
    btn.textContent = 'Register';
    btn.onclick = () => registerClass(c.id);
    card.appendChild(btn);
    classesDiv.appendChild(card);
  });
}

async function refreshMyRegs() {
  myRegsDiv.innerHTML = '';
  const studentId = studentSelect.value;
  if (!studentId) return;
  const res = await axios.get('/api/registration/me', { params: { student_id: studentId } });
  const data = res.data.data || res.data;
  data.forEach(r => {
    const div = document.createElement('div');
    div.className = 'p-2 border rounded mb-2';
    div.innerHTML = `<div><strong>${r.courseName || r.course_class_id}</strong></div><div class='text-sm'>Status: ${r.status}</div>`;
    myRegsDiv.appendChild(div);
  });
}

async function registerClass(offeringId) {
  const studentId = studentSelect.value;
  const regPeriodId = periodSelect.value;
  if (!studentId || !regPeriodId) {
    alert('Chọn student và đợt đăng ký');
    return;
  }

  // Find the course ID from the selected offering
  const offering = classes.find(c => c.id === offeringId);
  if (!offering) {
    alert('Course offering not found');
    return;
  }

  try {
    const payload = {
      studentId: studentId,
      courseId: offering.courseId, // Use courseId from the offering
      registrationPeriodId: regPeriodId,
      registrationType: 1
    };
    await axios.post('/api/registration', payload);
    alert('Đăng ký thành công');
    await refreshMyRegs();
  } catch (err) {
    console.error(err);
    alert('Error: ' + (err.response?.data?.message || err.message));
  }
}

// Event listeners
studentSelect.addEventListener('change', async () => {
  await loadPeriods();
  await refreshMyRegs();
});
periodSelect.addEventListener('change', async () => {
  await loadClasses();
  renderClasses();
  await refreshMyRegs();
});

init().then(() => refreshMyRegs());

