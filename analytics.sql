-- ============================================================================
-- CORPORATE EXECUTIVE REVENUE & OPERATIONAL KPI INSIGHTS
-- ============================================================================

-- KPI 1: Monthly Financial Performance Report (Gross Revenue, Tax Loss & Cancellation Rate)
SELECT 
    DATE_FORMAT(created_at, '%Y-%m') AS fiscal_month,
    COUNT(booking_id) AS total_gross_transactions,
    SUM(CASE WHEN booking_status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_transactions,
    ROUND((SUM(CASE WHEN booking_status = 'Cancelled' THEN 1 ELSE 0 END) / COUNT(booking_id)) * 100, 2) AS cancellation_rate_pct,
    ROUND(SUM(CASE WHEN booking_status != 'Cancelled' THEN total_amount ELSE 0 END), 2) AS net_settled_revenue,
    ROUND(SUM(CASE WHEN booking_status != 'Cancelled' THEN tax_amount ELSE 0 END), 2) AS total_tax_liabilities
FROM core_bookings
GROUP BY fiscal_month
ORDER BY fiscal_month DESC;

-- KPI 2: Dynamic Channel Mix Optimization Matrix
SELECT 
    booking_channel,
    COUNT(booking_id) AS volume_of_stays,
    ROUND(SUM(total_amount), 2) AS total_channel_revenue,
    ROUND(AVG(DATEDIFF(check_out_date, check_in_date)), 1) AS average_length_of_stay,
    ROUND(AVG(total_amount / DATEDIFF(check_out_date, check_in_date)), 2) AS ADR -- Average Daily Rate per Channel
FROM core_bookings
WHERE booking_status IN ('Active', 'Checked_In', 'Checked_Out')
GROUP BY booking_channel
ORDER BY total_channel_revenue DESC;
