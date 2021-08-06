<?php

namespace App\Http\Controllers;
use App\Models\Task;
use Illuminate\Http\Request;

class TaskController extends Controller
{
    public function createTask(Request $request){

        //variables that uses $request without validation
        $userID = $request->userID; //forgein key
        $taskListID = $request->taskListID; //forgein key
        $taskStartDate = $request->taskStartDate;
        $taskDueDate = $request->taskDueDate;
        $taskStatus = $request->taskStatus;
        $taskCollabUserId = $request->taskCollabUserId; //not planning to implement this function yet
        $taskAssignedMemberId = $request->taskAssignedMemberId; //not planning to implement this function yet

        $fields = $request->validate([
            'taskName' => ['required', 'string'],
            'taskDesc' => ['string'],
        ]);

        //create task
        $task = Task::create([
            'task_taskListID' => $taskListID,
            'task_name' => $fields['taskName'],
            'task_desc' => $fields['taskDesc'],
            'task_userCreateID' => $userID,
            'task_assignedMemberID' => $userID,
            'task_startDate' => $taskStartDate,
            'task_dueDate' => $taskDueDate,
            'task_status' => $taskStatus,
        ]);

        return [
            'message'=>'Task created.'
        ];
    }

    public function getTaskByTaskListID(Request $request){

        //variables that uses $request without validation
        $taskListID = $request->taskListID;

        $task = Task::where('task_taskListID', $taskListID)->get();

        return response($task, 200);
    }

    public function getTaskByID(Request $request){

        //variables that uses $request without validation
        $taskID = $request->taskID;

        $task = Task::where('id', $taskID)->first();

        return response($task, 200);
    }
    
    public function updateTask(Request $request){

        //variables that uses $request without validation
        $taskID = $request->taskID;
        $taskStartDate = $request->taskStartDate;
        $taskDueDate = $request->taskDueDate;
        $taskStatus = $request->taskStatus;
        $taskCollabUserId = $request->taskCollabUserId; //not planning to implement this function yet
        $taskAssignedMemberId = $request->taskAssignedMemberId; //not planning to implement this function yet

        $fields = $request->validate([
            'taskName' => ['required', 'string'],
            'taskDesc' => ['string'],
        ]);

        $task = Task::where('id', $taskID)->first();
        $task->task_name = $fields['taskName'];
        $task->task_desc = $fields['taskDesc'];
        $task->task_startDate = $taskStartDate;
        $task->task_dueDate = $taskDueDate;
        $task->task_status = $taskStatus;
        $task->save();

        return [
            'message'=>'Task updated.'
        ];
    }

    public function assignTask(Request $request){

        //variables that uses $request without validation
        $taskID = $request->taskID;
        $assignedUserID = $request->assignedUserID; // only can assign to one member

        $task = Task::where('id', $taskID)->first();
        $taskAssignedMemberList = $task->task_assignedMemberID;

        $taskAssignedMemberListNew = $taskAssignedMemberList. ',' .$assignedUserID;
        $task->task_assignedMemberID = $taskAssignedMemberListNew;
        $task->save();
        
        return [
            'message'=>'Task assigned.'
        ];
    }

    public function taskAssignedToUser(Request $request){

        //variables that uses $request without validation
        $taskListID = $request->taskListID;
        $user = $request->userID;

        $task = Task::where('task_taskListID', $taskListID)
                    ->where('task_assignedMemberID', 'like', '%'.$user.'%')
                    ->get();

        return response($task, 200);
    }
}
