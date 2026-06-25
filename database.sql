CREATE DATABASE IF NOT EXISTS db_sekolah;
USE db_sekolah;

-- Tabel User
CREATE TABLE IF NOT EXISTS users (
    id_user INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'guru', 'siswa') NOT NULL,
    nama_lengkap VARCHAR(100) NOT NULL
);

-- Tabel Kelas
CREATE TABLE IF NOT EXISTS kelas (
    id_kelas INT AUTO_INCREMENT PRIMARY KEY,
    nama_kelas VARCHAR(50) NOT NULL,
    wali_kelas VARCHAR(20) -- Akan di-link ke nip guru
);

-- Tabel Siswa
CREATE TABLE IF NOT EXISTS siswa (
    nis VARCHAR(20) PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    jenis_kelamin ENUM('L', 'P') NOT NULL,
    alamat TEXT,
    tanggal_lahir DATE,
    id_kelas INT,
    FOREIGN KEY (id_kelas) REFERENCES kelas(id_kelas) ON DELETE SET NULL
);

-- Tabel Guru
CREATE TABLE IF NOT EXISTS guru (
    nip VARCHAR(20) PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    alamat TEXT,
    nomor_telepon VARCHAR(15),
    mata_pelajaran VARCHAR(100)
);

-- Tabel Mata Pelajaran
CREATE TABLE IF NOT EXISTS mapel (
    id_mapel INT AUTO_INCREMENT PRIMARY KEY,
    nama_mapel VARCHAR(100) NOT NULL,
    nip_guru VARCHAR(20),
    FOREIGN KEY (nip_guru) REFERENCES guru(nip) ON DELETE SET NULL
);

-- Update Tabel Kelas untuk relasi ke guru (wali kelas)
ALTER TABLE kelas ADD CONSTRAINT fk_wali_kelas FOREIGN KEY (wali_kelas) REFERENCES guru(nip) ON DELETE SET NULL;

-- Tabel Jadwal Pelajaran
CREATE TABLE IF NOT EXISTS jadwal (
    id_jadwal INT AUTO_INCREMENT PRIMARY KEY,
    hari ENUM('Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu') NOT NULL,
    jam_mulai TIME NOT NULL,
    jam_selesai TIME NOT NULL,
    id_kelas INT,
    id_mapel INT,
    nip_guru VARCHAR(20),
    FOREIGN KEY (id_kelas) REFERENCES kelas(id_kelas) ON DELETE CASCADE,
    FOREIGN KEY (id_mapel) REFERENCES mapel(id_mapel) ON DELETE CASCADE,
    FOREIGN KEY (nip_guru) REFERENCES guru(nip) ON DELETE CASCADE
);

-- Tabel Absensi
CREATE TABLE IF NOT EXISTS absensi (
    id_absensi INT AUTO_INCREMENT PRIMARY KEY,
    nis VARCHAR(20),
    tanggal DATE NOT NULL,
    status ENUM('Hadir', 'Sakit', 'Izin', 'Alpha') NOT NULL,
    FOREIGN KEY (nis) REFERENCES siswa(nis) ON DELETE CASCADE
);

-- Tabel Nilai
CREATE TABLE IF NOT EXISTS nilai (
    id_nilai INT AUTO_INCREMENT PRIMARY KEY,
    nis VARCHAR(20),
    id_mapel INT,
    tugas DECIMAL(5,2) DEFAULT 0,
    uts DECIMAL(5,2) DEFAULT 0,
    uas DECIMAL(5,2) DEFAULT 0,
    nilai_akhir DECIMAL(5,2) DEFAULT 0,
    FOREIGN KEY (nis) REFERENCES siswa(nis) ON DELETE CASCADE,
    FOREIGN KEY (id_mapel) REFERENCES mapel(id_mapel) ON DELETE CASCADE
);

-- Tabel Pengumuman
CREATE TABLE IF NOT EXISTS pengumuman (
    id_pengumuman INT AUTO_INCREMENT PRIMARY KEY,
    judul VARCHAR(255) NOT NULL,
    isi TEXT NOT NULL,
    tanggal_posting DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_user INT,
    FOREIGN KEY (id_user) REFERENCES users(id_user) ON DELETE SET NULL
);

-- Insert Dummy Data (Password is 'password')
INSERT INTO users (username, password, role, nama_lengkap) VALUES 
('admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'Administrator'),
('guru1', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'guru', 'Budi Santoso, S.Pd'),
('siswa1', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'siswa', 'Andi Pratama');

INSERT INTO guru (nip, nama, alamat, nomor_telepon, mata_pelajaran) VALUES 
('198001012005011001', 'Budi Santoso, S.Pd', 'Jl. Merdeka No. 1', '081234567890', 'Matematika');

INSERT INTO kelas (nama_kelas, wali_kelas) VALUES 
('X IPA 1', '198001012005011001');

INSERT INTO siswa (nis, nama, jenis_kelamin, alamat, tanggal_lahir, id_kelas) VALUES 
('1001', 'Andi Pratama', 'L', 'Jl. Sudirman No. 2', '2005-05-15', 1);

INSERT INTO mapel (nama_mapel, nip_guru) VALUES 
('Matematika', '198001012005011001');

INSERT INTO jadwal (hari, jam_mulai, jam_selesai, id_kelas, id_mapel, nip_guru) VALUES 
('Senin', '07:00:00', '08:30:00', 1, 1, '198001012005011001');
