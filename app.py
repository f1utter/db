from flask import Flask, request, Response
import sqlite3,json

app=Flask(__name__);
db_locale="practice.db";

@app.route('/add', methods=["POST"])
def add():
    if request.method=='POST':
        conn=sqlite3.connect(db_locale)
        c=conn.cursor()
        c.execute(
            """insert into practable(serialNo, dbData) values(?,?)""",
            (request.headers["serialNo"], request.headers["dbData"])
        )
        conn.commit()
        conn.close()
        return Response(status=200)

@app.route('/view', methods=["GET"])
def view():
    if request.method=='GET':
        conn=sqlite3.connect(db_locale)
        c=conn.cursor()
        sqlres=c.execute("""select * from practable""").fetchall()
        conn.commit()
        conn.close()
        res=[]
        for sno in sqlres:
            obj={}
            obj['serialNo']=sno[0]
            obj['dbData']=sno[1]
            res.append(obj)
        finalres={}
        finalres['result']=res
        return json.dumps(finalres)

if __name__=='__main__':
    app.run(host='0.0.0.0', port=5000)
