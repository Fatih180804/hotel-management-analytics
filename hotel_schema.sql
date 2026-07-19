-- ============================================================================
-- ENTERPRISE HOTEL RESOURCE MANAGEMENT (ERP) & ANALYTICS SCHEMA
-- Version: 1.1 | Optimization: High-Concurrency Environments
-- ============================================================================

-- 1. CLIENT DATA MANAGEMENT (CRM)
CREATE TABLE crm_guests (
    guest_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(60) NOT NULL,
    last_name VARCHAR(60) NOT NULL,
    email VARCHAR(120) UNIQUE NOT NULL,
    phone_number VARCHAR(25) NOT NULL,
    passport_country_code CHAR(3) NOT NULL, -- ISO 3166-1 alpha-3 (E.g., TUR, USA)
    loyalty_tier ENUM('Standard', 'Silver', 'Gold', 'Platinum') DEFAULT 'Standard',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. INVENTORY & DYNAMIC PRICING ENGINE
CREATE TABLE inv_rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_number VARCHAR(12) UNIQUE NOT NULL,
    room_type ENUM('Standard_Twin', 'Deluxe_King', 'Executive_Suite', 'Presidential_Suite') NOT NULL,
    base_price_per_night DECIMAL(12, 2) NOT NULL,
    current_status ENUM('Available', 'Occupied', 'Housekeeping', 'Out_Of_Order') DEFAULT 'Available',
    floor_number INT NOT NULL
);

-- 3. TRANSACTIONAL RESERVATION LEDGER
CREATE TABLE core_bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id INT NOT NULL,
    room_id INT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    booking_channel ENUM('Direct_Website', 'Booking_com', 'Expedia', 'Corporate_Contract') NOT NULL,
    payment_status ENUM('Pending', 'Authorized', 'Settled', 'Refunded') DEFAULT 'Pending',
    booking_status ENUM('Active', 'Checked_In', 'Checked_Out', 'No_Show', 'Cancelled') DEFAULT 'Active',
    net_amount DECIMAL(12, 2) NOT NULL,
    tax_amount DECIMAL(12, 2) NOT NULL,
    total_amount DECIMAL(12, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (guest_id) REFERENCES crm_guests(guest_id) ON DELETE RESTRICT,
    FOREIGN KEY (room_id) REFERENCES inv_rooms(room_id) ON DELETE RESTRICT
);

-- ============================================================================
-- PERFORMANCE TUNING & INDEXING INFRASTRUCTURE
-- Optimized for high-read dashboard pipelines and overlapping date searches.
-- ============================================================================
CREATE INDEX idx_booking_date_window ON core_bookings (check_in_date, check_out_date);
CREATE INDEX idx_guest_loyalty ON crm_guests (loyalty_tier);
CREATE INDEX idx_room_operational ON inv_rooms (room_type, current_status);
