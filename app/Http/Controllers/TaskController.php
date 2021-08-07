<?php

namespace App\Http\Controllers;
use App\Models\Task;
use App\Models\TaskList;
use Illuminate\Http\Request;

class TaskController extends Controller
{
    /*
        taskStatus docs
        0 = completed task
        1 = active task
    */
    public function createTask(Request $request){

        //variables that uses $request without validation
        $userID = $request->userID; //forgein key
        $taskListID = $request->taskListID; //forgein key
        $taskTeamID = $request->taskTeamID; //forgein key
        $taskStartDate = $request->taskStartDate;
        $taskDueDate = $request->taskDueDate;
        $taskStatusMsg = $request->taskStatusMsg;
        $taskCollabUserId = $request->taskCollabUserId; //not planning to implement this function yet
        $taskAssignedMemberId = $request->taskAssignedMemberId; //not planning to implement this function yet

        $fields = $request->validate([
            'taskName' => ['required', 'string'],
            'taskDesc' => ['string'],
        ]);

        //check if user belongs to the taskList
        $taskList = TaskList::where('id', $taskListID)->first();
        if($taskList->taskList_userID == $userID){
            //create task
            $task = Task::create([
                'task_taskListID' => $taskListID,
                'task_teamID' => $taskTeamID,
                'task_name' => $fields['taskName'],
                'task_desc' => $fields['taskDesc'],
                'task_userCreateID' => $userID,
                'task_startDate' => $taskStartDate,
                'task_dueDate' => $taskDueDate,
                'task_statusMsg' => $taskStatusMsg,
                'task_status' => '1',
            ]);

            return [
                'message'=>'Task created.'
            ];
        }else{
            return [
                'message'=>'Please create new task in your own task list.'
            ];
        }
    }

    public function getTaskByTaskListID(Request $request){

        //variables that uses $request without validation
        $taskListID = $request->taskListID;

        $task = Task::where('task_taskListID', $taskListID)
                        ->where('task_status' , 1)->get();

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
        $taskStatusMsg = $request->taskStatusMsg;
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
        $task->task_statusMsg = $taskStatusMsg;
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

        if(strlen($taskAssignedMemberList) == 0){
            $taskAssignedMemberListNew = $assignedUserID;
        }else{
            $taskAssignedMemberListNew = $taskAssignedMemberList. ',' .$assignedUserID;
        }
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

        $task = Task::where('task_assignedMemberID', 'like', '%'.$user.'%')
                        ->where('task_status' , 1)->get();

        return response($task, 200);
    }

    public function changeTaskStatus(Request $request){
        
        //variables that uses $request without validation
        $taskID = $request->taskID;
        $taskStatus = $request->taskStatus;

        $changedTaskStatus = $taskStatus==1 ? 0 : 1;

        $task = Task::where('id', $taskID)->first();
        $task->task_status = $changedTaskStatus;
        $task->save();

        return [
            'message'=>'Task status updated.'
        ];
    }
}
