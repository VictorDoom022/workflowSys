<?php

namespace App\Http\Controllers;
use App\Models\Task;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class DashboardController extends Controller
{

    public function getUserTaskOverview(Request $request){

        //variables that uses $request without validation
        $userID = $request->userID;

        //total task from user
        $totalTask = Task::where('task_userCreateID', $userID)
                    ->count();

        //current user active task count
        $activeTaskCount = Task::where('task_userCreateID', $userID)
                    ->where('task_status', 1)
                    ->count();

        //current user active task count
        $completedTaskCount = Task::where('task_userCreateID', $userID)
                    ->where('task_status', 0)
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
        $assignedToUserTaskCount = Task::where('task_assignedMemberID', 'like', '%'.$userID.'%')
                    ->where('task_status', 1)
                    ->count();

        //start of user last activity graph data
        $taskRecentActivity = Task::where('task_userCreateID', $userID)
                    ->orderBy('updated_at')
                    ->get()
                    ->groupBy(function($item){
                        return $item->updated_at->format('Y-m-d');
                    });

        $recentTaskActivityArray =  array();
        foreach ($taskRecentActivity as $key => $tasks){
            $day = $key;
            $totalCount = $tasks->count();

            $dataArray = array(
                'date' => $day,
                'taskCount' => $totalCount,
            );
            array_push($recentTaskActivityArray, $dataArray);
        }
        //end of user last activity graph data

        //start of user completed task history graph data
        $completedTaskHistory = Task::where('task_userCreateID', $userID)
                    ->where('task_status', 0)
                    ->orderBy('updated_at')
                    ->get()
                    ->groupBy(function($item){
                        return $item->updated_at->format('Y-m-d');
                    });

        $completedTaskHistoryArray =  array();
        foreach ($completedTaskHistory as $key => $tasks){
            $day = $key;
            $totalCount = $tasks->count();

            $dataArray = array(
                'date' => $day,
                'taskCount' => $totalCount,
            );
            array_push($completedTaskHistoryArray, $dataArray);
        }
        //end of user completed task history graph data

        $response = [
            'totalTask' => $totalTask,
            'activeTaskCount' => $activeTaskCount,
            'completedTaskCount' => $completedTaskCount,
            'highPriorityTaskCount' => $highPriorityTaskCount,
            'assignedToUserTaskCount' => $assignedToUserTaskCount,
            'recentTaskActivityData' => $recentTaskActivityArray,
            'completedTaskHistoryData' => $completedTaskHistoryArray,
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

    public function getTaskLastActivityGraphData(Request $request){

        //variables that uses $request without validation
        $userID = $request->userID;

        $task = Task::where('task_userCreateID', $userID)
                    ->orderBy('updated_at')
                    ->get()
                    ->groupBy(function($item){
                        return $item->updated_at->format('Y-m-d');
                    });

        $chartDataArray =  array();
        foreach ($task as $key => $tasks){
            $day = $key;
            $totalCount = $tasks->count();

            $dataArray = array(
                'date' => $day,
                'taskCount' => $totalCount,
            );
            array_push($chartDataArray, $dataArray);
        }

        return response($chartDataArray, 200);
    }

    public function getCompletedTaskGraphData(Request $request){

        //variables that uses $request without validation
        $userID = $request->userID;

        $task = Task::where('task_userCreateID', $userID)
                    ->where('task_status', 0)
                    ->orderBy('updated_at')
                    ->get()
                    ->groupBy(function($item){
                        return $item->updated_at->format('Y-m-d');
                    });

        $chartDataArray =  array();
        foreach ($task as $key => $tasks){
            $day = $key;
            $totalCount = $tasks->count();

            $dataArray = array(
                'date' => $day,
                'taskCount' => $totalCount,
            );
            array_push($chartDataArray, $dataArray);
        }

        return response($chartDataArray, 200);
    }
}
