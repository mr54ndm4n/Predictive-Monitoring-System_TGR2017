rgbcolor = imread('rgb.png'); %เก็บรูปภาพไว้ในตัวแปร rgbcolor
imshow(rgbcolor) %แสดงรุปภาพในตัวแปร rgbcolor
figure;imshow(rgbcolor);title('RGB COLOR') %//สร้างกรอบให้รูปภาพ(ตัวแปร rgbcolor) พร้อมไตเติล(RGB COLOR)
rgbcolor(:,:,2)=0; %//ให้ตัวแปร rgbcolor เซ็ตค่าสี จากสีเขียวให้เป็นสีดำ (Red=1;Green=2;Blue=3;) ส่วนค่า 0 เท่ากับสีดำ 1 เท่ากับสีขาว 
rgbcolor(:,:,3)=0; %//ให้ตัวแปร rgbcolor เซ็ตค่าสี จากสีน้ำเงินให้เป็นสีดำ
redcolor = rgbcolor; %// กำหนดให้ตัวแปร redcolor มีค่าเท่ากับ rgbcolor
figure;imshow(redcolor);title('RED COLOR')% //สร้างกรอบให้รูปภาพ(ตัวแปร redcolor) พร้อมไตเติล(RED COLOR)