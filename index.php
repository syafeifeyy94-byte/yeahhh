<?php
require_once 'config/database.php';
include 'layout/header.php';

// Fetch stats based on role
$role = $_SESSION['role'];

// Common Stats (Admin sees all, Guru/Siswa sees some)
$jml_siswa = $pdo->query("SELECT COUNT(*) FROM siswa")->fetchColumn();
$jml_guru = $pdo->query("SELECT COUNT(*) FROM guru")->fetchColumn();
$jml_kelas = $pdo->query("SELECT COUNT(*) FROM kelas")->fetchColumn();
$jml_mapel = $pdo->query("SELECT COUNT(*) FROM mapel")->fetchColumn();

// Get Pengumuman
$pengumuman = $pdo->query("SELECT p.*, u.nama_lengkap FROM pengumuman p LEFT JOIN users u ON p.id_user = u.id_user ORDER BY tanggal_posting DESC LIMIT 3")->fetchAll();

?>

<h2 class="mb-4">Dashboard</h2>

<?php if($role == 'admin' || $role == 'guru'): ?>
<!-- Stats Row -->
<div class="row mb-4">
    <div class="col-md-3">
        <div class="card h-100">
            <div class="stat-widget">
                <div class="stat-icon bg-primary-grad"><i class="fas fa-user-graduate"></i></div>
                <div>
                    <h5 class="mb-0 text-muted">Siswa</h5>
                    <h3 class="mb-0 fw-bold"><?= $jml_siswa ?></h3>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card h-100">
            <div class="stat-widget">
                <div class="stat-icon bg-success-grad"><i class="fas fa-chalkboard-teacher"></i></div>
                <div>
                    <h5 class="mb-0 text-muted">Guru</h5>
                    <h3 class="mb-0 fw-bold"><?= $jml_guru ?></h3>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card h-100">
            <div class="stat-widget">
                <div class="stat-icon bg-warning-grad"><i class="fas fa-door-open"></i></div>
                <div>
                    <h5 class="mb-0 text-muted">Kelas</h5>
                    <h3 class="mb-0 fw-bold"><?= $jml_kelas ?></h3>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card h-100">
            <div class="stat-widget">
                <div class="stat-icon bg-danger-grad"><i class="fas fa-book"></i></div>
                <div>
                    <h5 class="mb-0 text-muted">Mata Pelajaran</h5>
                    <h3 class="mb-0 fw-bold"><?= $jml_mapel ?></h3>
                </div>
            </div>
        </div>
    </div>
</div>
<?php endif; ?>

<div class="row">
    <!-- Chart Absensi (Admin) -->
    <div class="col-md-8 mb-4">
        <div class="card h-100">
            <div class="card-header d-flex justify-content-between align-items-center">
                <span><i class="fas fa-chart-bar me-2"></i> Grafik Kehadiran Bulan Ini</span>
            </div>
            <div class="card-body">
                <canvas id="absensiChart" height="100"></canvas>
            </div>
        </div>
    </div>
    
    <!-- Pengumuman -->
    <div class="col-md-4 mb-4">
        <div class="card h-100">
            <div class="card-header">
                <i class="fas fa-bell me-2 text-warning"></i> Pengumuman Terbaru
            </div>
            <div class="card-body p-0">
                <ul class="list-group list-group-flush">
                    <?php if(count($pengumuman) > 0): ?>
                        <?php foreach($pengumuman as $p): ?>
                            <li class="list-group-item bg-transparent">
                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <strong class="text-primary"><?= htmlspecialchars($p['judul']) ?></strong>
                                    <small class="text-muted" style="font-size:0.75rem"><?= date('d M', strtotime($p['tanggal_posting'])) ?></small>
                                </div>
                                <p class="mb-1 small"><?= htmlspecialchars(substr($p['isi'], 0, 80)) ?>...</p>
                                <small class="text-muted"><i class="fas fa-user-edit me-1"></i><?= htmlspecialchars($p['nama_lengkap']) ?></small>
                            </li>
                        <?php endforeach; ?>
                    <?php else: ?>
                        <li class="list-group-item text-center text-muted">Belum ada pengumuman</li>
                    <?php endif; ?>
                </ul>
            </div>
            <div class="card-footer text-center bg-transparent">
                <a href="/TUGAS UAS PAK MARDI/<?= $role ?>/pengumuman.php" class="text-decoration-none small">Lihat Semua</a>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const ctx = document.getElementById('absensiChart').getContext('2d');
    
    // Gradient for chart
    let gradientHadir = ctx.createLinearGradient(0, 0, 0, 400);
    gradientHadir.addColorStop(0, 'rgba(25, 135, 84, 0.5)');
    gradientHadir.addColorStop(1, 'rgba(25, 135, 84, 0.05)');

    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Minggu 1', 'Minggu 2', 'Minggu 3', 'Minggu 4'],
            datasets: [{
                label: 'Siswa Hadir',
                data: [120, 115, 125, 110], // Dummy Data, idealnya query dari DB GROUP BY week
                backgroundColor: gradientHadir,
                borderColor: '#198754',
                borderWidth: 2,
                borderRadius: 5
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: { display: false }
            },
            scales: {
                y: { beginAtZero: true }
            }
        }
    });
});
</script>

<?php include 'layout/footer.php'; ?>
