firestore/
├── schedules/
│   ├── schedule_001/
│   │   ├── movieName: "Avengers"
│   │   ├── showTime: timestamp
│   │   ├── ticketPrice: 50000
│   │   ├── totalSeats: 100
│   │   └── availableSeats: 85
│   │
│   └── schedule_002/
│
├── bookings/
│   ├── booking_001/
│   │   ├── userId: "user123"
│   │   ├── scheduleId: "schedule_001"
│   │   ├── selectedSeats: ['A1', 'A2']
│   │   ├── totalPrice: 100000
│   │   ├── status: "pending"
│   │   └── paymentDeadline: timestamp
│   │
│   └── booking_002/
│
├── payments/
│   ├── payment_001/
│   │   ├── bookingId: "booking_001"
│   │   ├── amount: 100000
│   │   ├── status: "success"
│   │   └── paymentTime: timestamp
│   │
│   └── payment_002/
│
└── users/
    └── [existing user documents]