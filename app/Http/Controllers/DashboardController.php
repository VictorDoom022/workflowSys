<?php

namespace App\Http\Controllers;
use App\Models\Task;
use Illuminate\Http\Request;

class DashboardController extends Controller
{

    public function getUserTaskOverview(Request $request){

        //variables that uses $request without validation
        $userID = $request->userID;

        //current user active task count
        $activeTaskCount = Task::where('task_userCreateID', $userID)
                    ->where('task_status', 1)
                    ->count();

        //user task with high priority count
        $highPriorityTaskCount = Task::where('task_userCreateID', $userID)
                    ->where('task_status', 1)
                    ->where(function ($query){
                        $query->orWhere('task_priority', '=', 3)
                            ->orWhere('task_priority', '=', 4);
                    })
                    ->count();

        //show curent task being assigend to user count (not completed)
        $assigendToUserTaskCount = Task::where('task_assignedMemberID', 'like', '%'.$userID.'%')
                    ->where('task_status', 1)
                    ->count();

        $response = [
            'activeTaskCount' => $activeTaskCount,
            'highPriorityTaskCount' => $highPriorityTaskCount,
            'assigendToUserTaskCount' => $assigendToUserTaskCount,
        ];

        return response($response, 200);
    }

    //show current user active task count
    public function getUserActiveTask(Request $request){

        //variables that uses $request without validation
        $userID = $request->userID;

        $task = Task::where('task_userCreateID', $userID)
                    ->where('task_status', 1)
                    ->get();

        return response($task, 200);
    }

    //show user task with high priority count
    public function getHighPriorityTask(Request $request){

        //variables that uses $request without validation
        $userID = $request->userID;

        $task = Task::where('task_userCreateID', $userID)
                    ->where('task_status', 1)
                    ->where(function ($query){
                        $query->orWhere('task_priority', '=', 3)
                            ->orWhere('task_priority', '=', 4);
                    })
                    ->get();

        return response($task, 200);
    }

    //show user completed task count

    //show curent task being assigend to user count (not completed)
    public function getAssigendToUserTask(Request $request){

        //variables that uses $request without validation
        $userID = $request->userID;

        $task = Task::where('task_assignedMemberID', 'like', '%'.$userID.'%')
                    ->where('task_status', 1)
                    ->get();

        return response($task, 200);
    }
}
