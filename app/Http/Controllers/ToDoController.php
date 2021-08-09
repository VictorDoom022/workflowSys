<?php

namespace App\Http\Controllers;
use App\Models\ToDo;
use Illuminate\Http\Request;

class ToDoController extends Controller
{
    /*
        todo docs
        0 = archived todo
        1 = active todo
    */
    public function createTodo(Request $request){

        //variables that uses $request without validation
        $userID = $request->userID;
        $todoStartDate = $request->todoStartDate;
        $todoDueDate = $request->todoDueDate;

        $fields = $request->validate([
            'todoName' => ['required', 'string'],
            'todoDesc' => ['string'],
            'todoStatusMsg' => ['string'],
        ]);

        $todo = ToDo::create([
            'todo_userID' => $userID,
            'todo_name' => $fields['todoName'],
            'todo_desc' => $fields['todoDesc'],
            'todo_startDate' => $todoStartDate,
            'todo_dueDate' => $todoDueDate,
            'todo_statusMsg' => $fields['todoStatusMsg'],
            'todo_status' => 1,
        ]);

        return [
            'message'=>'Todo created.'
        ];
    }

    public function getTodoByID(Request $request){

        //variables that uses $request without validation
        $todoID = $request->todoID;

        $todo = ToDo::where('id', $todoID)->first();

        return response($todo, 200);
    }

    public function getToDoByUserID(Request $request){

        //variables that uses $request without validation
        $userID = $request->userID;
        
        $todo = ToDo::where('todo_userID', $userID)
                        ->where('todo_status', 1)->get();

        return response($todo, 200);
    }

    public function updateTodo(Request $request){

        //variables that uses $request without validation
        $todoID = $request->todoID;
        $todoStartDate = $request->todoStartDate;
        $todoDueDate = $request->todoDueDate;

        $fields = $request->validate([
            'todoName' => ['required', 'string'],
            'todoDesc' => ['string'],
            'todoStatusMsg' => ['string'],
        ]);

        $todo = ToDo::where('id', $todoID)->first();
        $todo->todo_name = $fields['todoName'];
        $todo->todo_desc = $fields['todoDesc'];
        $todo->todo_startDate = $todoStartDate;
        $todo->todo_dueDate = $todoDueDate;
        $todo->todo_statusMsg = $fields['todoStatusMsg'];
        $todo->save();

        return [
            'message'=>'Todo updated.'
        ];
    }

    public function changeTodoStatus(Request $request){

        //variables that uses $request without validation
        $todoID = $request->todoID;
        $todoStatus = $request->todoStatus;

        $changeTodoStatus = $todoStatus==1 ? 0: 1;

        $todo = ToDo::where('id', $todoID)->first();
        $todo->todo_status = $changeTodoStatus;
        $todo->save();

        return [
            'message'=>'Todo status updated.'
        ];
    }

    public function deleteTodoById($id){
     
        $todo = ToDo::where('id', $id)->delete();
        
        return [
            'message'=>'Todo deleted.'
        ];
    }
}
