import ast
import operator
import sqlite3
from flask import Flask,jsonify,request
from database import get_connection,initialize_database
app=Flask(__name__)
initialize_database()
OPERATORS={
ast.Add:operator.add,
ast.Sub:operator.sub,
ast.Mult:operator.mul,
ast.Div:operator.truediv,
ast.Mod:operator.mod,
ast.USub:operator.neg,
ast.UAdd:operator.pos,
}

def evaluate_expression(expression):
    expression=(
    expression.replace("x","*")
    .replace("X","*")
    .replace("divide","/")
    )
    try:
        tree=ast.parse(expression,mode="eval")
    except SyntaxError:
        raise ValueError("Invalid mathematical expression")
    def evaluate(node):
        if isinstance(node,ast.Expression):
            return evaluate(node.body)
        if isinstance(node,ast.Constant):
            if type(node.value) not in (int,float):
                raise ValueError("Only numbers are allowed")
                return node.value
            if isinstance(node,ast.BinOp):
                operation=OPERATORS.get(type(node.op))
                if operation is None:
                    raise ValueError("Unsupported operator")
                left=evaluate(node.left)
                right=evaluate(node.right)
                if isinstance(node.op,ast.Div) and right==0:
                    raise ValueError("Cannot divide by zero")
                result=operation(left,right)
                if isinstance(result,(int,float)):
                    if abs(result)>1e100:
                        raise ValueError("Result is too large")
                return result
            if isinstance(node,ast.UnaryOp):
                operation=OPERATORS.get(type(node.op))
                if operation is None:
                    raise ValueError("Unsupported operator")
                return operation(evaluate(node.operand))
            raise ValueError("Unsupported expression")
        result=evaluate(tree)
        if isinstance(result,float):
            if not(-float("inf")<result<float("inf")):
                raise ValueError("Result is not finite")
        return result

@app.route("/calculate",methods=["POST"])
def calculate():
    data=request.get_json(silent=True) or {}
    expression=data.get("expression")
    if not isinstance(expression,str) or not expression.strip():
        return jsonify({"Error":"Expression is required "}),400
    if len(expression)>200:
        return jsonify({"Error":"Expression is too long"}),400
    try:
        answer=evaluate_expression(expression)
    except (ValueError,ZeroDivisionError,OverflowError):
        return jsonify({"Error":"Invalid calculation"}),400

    if isinstance(answer,int):
        formatted_result=str(answer)
    elif isinstance(answer,float):
        formatted_result=format(answer,".10g")
    else:
        formatted_result=str(answer)
    connection=get_connection()
    cursor=connection.execute(
    "INSERT INTO history (expression,result) VALUES(?,?)",(expression,formatted_result),
    )
    calculation_id=cursor.lastrowid
    connection.commit()
    connection.close()
    return jsonify({
    "id":calculation_id,
    "expression":expression,
    "result":formatted_result,
    }),201

@app.route("/history",methods=["GET"])
def get_history():
    connection=get_connection()
    rows=connection.execute("""
    SELECT id,expression,result,created_at FROM history ORDER BY id DESC
    """).fetchall()

    connection.close()
    return jsonify([dict(row) for row in rows])

@app.route("/history/<int:history_id>",methods=["DELETE"])
def delete_history_item(history_id):
    connection=get_connection()
    cursor=connection.execute("DELETE FROM history WHERE id=?",(history_id,),)
    connection.commit()
    deleted=cursor.rowcount>0
    connection.close()
    if not deleted:
        return jsonify({"Error":"History entry not found"}),404
    return jsonify({"message":"History entry deleted successfully"})

@app.route("/history",methods=["DELETE"])
def clear_history():
    connection=get_connection()
    connection.execute("DELETE FROM history")
    connection.commit()
    connection.close()
    return jsonify({"message":"History cleared"})

if __name__=="__main__":
    app.run(host="0.0.0.0",port=5000,debug=False)