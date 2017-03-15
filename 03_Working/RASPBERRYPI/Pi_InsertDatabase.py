import sqlite3 as lite

con = lite.connect('pic.db')	# Database File
def InsertDB(DATA, PIC_PATH):
        takeTime = strftime("%d-%m-%Y %H:%M:%S", localtime())
        print("INSERTING DATABASE...")
        with con:
                cur = con.cursor()
                # Field Table (NUM<Primary_Key>, MOYS<Text>, PIC_PATH<Text>, DATE<Text>)
                cur.execute( "insert into RPIDB VALUES(NULL, '{}', '{}', '{}');".format(DATA, PIC_PATH, takeTime))
        if con:
                con.close()
        print("COMPLETE INSERTING DATABASE!\n")