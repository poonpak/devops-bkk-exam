# ใช้ Base Image ที่เล็กที่สุด (Alpine)
FROM node:24-alpine

# สร้างโฟลเดอร์ทำงาน
WORKDIR /app

# Copy เฉพาะ package.json ก่อน (เพื่อ cache layer การ install)
COPY package.json ./

# ลง Library (เอาเฉพาะที่ใช้รันจริง)
RUN npm install --production

# Copy โค้ดที่เหลือ
COPY index.js ./

# เปิด Port (แค่บอก Docker ไว้ ไม่ได้เปิดจริง)
EXPOSE 4444

# คำสั่งรัน
CMD ["node", "index.js"]