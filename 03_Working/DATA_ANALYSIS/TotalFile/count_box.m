P=imread('box2.jpg'); %อ่านค่าจากภาพแล้วนำมาเก็บไว้ในตัวแปรในรูปแบบแมททริก
figure;imshow(P);
P=rgb2gray(P); %แปลงภาพสี(RGB) ให้เป็นโทนสีเท่า (ขาว-ดำ-เทา) (Gray Scale)
figure;imshow(P);
P=im2bw(P,graythresh(P));% หาค่าความแตกต่างในภาพอัตโนมัติ (เทรชโฮล) แล้วแปลงให้เป็นสีขาวดำ
figure;imshow(P);
P=~P; %ในขั้นตอนนี้จะเติมเต็มในส่วนที่เหลือแล้วสลับตำแหน่งสีขาวกับสีดำ
figure;imshow(P);
B = bwboundaries(P); %กำหนดขอบเขตในภาพแล้วเก็บไว้ในตัวแปร
figure;imshow(P);
text(10,10,strcat('\color{green}มีสี่เหลี่ยมทั้งหมด:',num2str(length(B)))) % เขียนข้อความลงบนภาพ



