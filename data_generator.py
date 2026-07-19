import random
from datetime import datetime, timedelta

class HotelDataPipelineSimulator:
    """
    Simulates production-grade transaction streams for database stress-testing.
    Generates high-fidelity, context-aware relational data points.
    """
    def __init__(self):
        self.channels = ['Direct_Website', 'Booking_com', 'Expedia', 'Corporate_Contract']
        self.room_configs = {
            'Standard_Twin': 90.00,
            'Deluxe_King': 160.00,
            'Executive_Suite': 320.00,
            'Presidential_Suite': 750.00
        }
        
    def generate_simulated_stream(self, batch_size=50):
        sql_outputs = []
        print(f"/* [PIPELINE INITIALIZED] Generating {batch_size} high-fidelity corporate transactions */")
        
        for _ in range(batch_size):
            stay_days = random.choices([1, 2, 3, 4, 5, 7, 14], weights=[15, 30, 25, 15, 8, 5, 2])[0]
            room_type = random.choices(list(self.room_configs.keys()), weights=[50, 35, 12, 3])[0]
            base_price = self.room_configs[room_type]
            
            start_offset = random.randint(-60, 60)
            check_in = datetime.now() + timedelta(days=start_offset)
            check_out = check_in + timedelta(days=stay_days)
            
            net_amt = base_price * stay_days
            tax_amt = net_amt * 0.18 # 18% VAT
            total_amt = net_amt + tax_amt
            
            channel = random.choice(self.channels)
            guest_id = random.randint(1, 1000)
            room_id = random.randint(1, 150)
            
            query = (
                f"INSERT INTO core_bookings (guest_id, room_id, check_in_date, check_out_date, "
                f"booking_channel, net_amount, tax_amount, total_amount, booking_status) "
                f"VALUES ({guest_id}, {room_id}, '{check_in.strftime('%Y-%m-%d')}', '{check_out.strftime('%Y-%m-%d')}', "
                f"'{channel}', {net_amt:.2f}, {tax_amt:.2f}, {total_amt:.2f}, 'Active');"
            )
            sql_outputs.append(query)
            
        return sql_outputs

if __name__ == "__main__":
    simulator = HotelDataPipelineSimulator()
    sample_queries = simulator.generate_simulated_stream(batch_size=3)
    for q in sample_queries:
        print(q)
