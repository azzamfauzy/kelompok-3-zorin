CREATE TABLE pelanggan (
    id_pelanggan INT PRIMARY KEY,
    nama_pelanggan VARCHAR(100)
);

CREATE TABLE pesanan (
    id_pesanan INT PRIMARY KEY,
    id_pelanggan INT,
    tanggal DATE,
    FOREIGN KEY (id_pelanggan) REFERENCES pelanggan(id_pelanggan)
);

CREATE TABLE detail_pesanan (
    id_detail INT PRIMARY KEY,
    id_pesanan INT,
    jumlah INT,
    harga_satuan DECIMAL(10,2),
    FOREIGN KEY (id_pesanan) REFERENCES pesanan(id_pesanan)
);

INSERT INTO pelanggan VALUES (1, 'Budi'), (2, 'Siti');
INSERT INTO pesanan VALUES (101, 1, '2026-10-01'), (102, 2, '2026-10-02');
INSERT INTO detail_pesanan VALUES (1, 101, 2, 50000), (2, 101, 1, 150000), (3, 102, 5, 20000);

    p.id_pelanggan,
    p.nama_pelanggan,
    SUM(dp.jumlah * dp.harga_satuan) AS kalkulasi_total_belanja
FROM pelanggan p
JOIN pesanan ps ON p.id_pelanggan = ps.id_pelanggan
JOIN detail_pesanan dp ON ps.id_pesanan = dp.id_pesanan
GROUP BY p.id_pelanggan, p.nama_pelanggan;

ALTER TABLE pelanggan
ADD COLUMN total_belanja DECIMAL(15,2) DEFAULT 0;

UPDATE pelanggan p
SET total_belanja = (
    SELECT COALESCE(SUM(dp.jumlah * dp.harga_satuan), 0)
    FROM pesanan ps
    JOIN detail_pesanan dp ON ps.id_pesanan = dp.id_pesanan
    WHERE ps.id_pelanggan = p.id_pelanggan
);

SELECT
    id_pelanggan,
    nama_pelanggan,
    total_belanja
FROM pelanggan;

