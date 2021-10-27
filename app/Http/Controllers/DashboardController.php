<?php

namespace App\Http\Controllers;
use App\Models\Task;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    //show current user active task count
    public function getUserActiveTask(Request $request){

        //variables that uses $request without validation
        $groupID = $request->groupID;
        $userID = $request->userID;

        $task = Task::where('task_userCreateID', $userID)
                    ->where('task_status', 1)
                    ->get();

        return response($task, 200);
    }

    //show user task with high priority count

    //show user completed task count

    //show curent task being assigend to user count (not completed)
}
