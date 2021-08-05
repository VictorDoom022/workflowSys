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
}
