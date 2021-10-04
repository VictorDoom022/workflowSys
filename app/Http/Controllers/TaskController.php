<?php

namespace App\Http\Controllers;
use App\Models\Task;
use App\Models\TaskList;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\File;

class TaskController extends Controller
{
    /*
        taskStatus docs
        0 = completed task
        1 = active task

        taskColor docs
        0 = default
        1 = blue (primary)
        2 = red (danger)
        3 = yellow (warning)
        4 = green (success)
        5 = grey (secondary)
        6 = black (dark)

        taskPriority docs
        0 = very low
        1 = Low
        2 = Medium (Default)
        3 = High
        4 = very High
    */
    public function createTask(Request $request){

        //variables that uses $request without validation
        $userID = $request->userID; //forgein key
        $taskListID = $request->taskListID; //forgein key
        $taskTeamID = $request->taskTeamID; //forgein key
        $taskStartDate = $request->taskStartDate;
        $taskDueDate = $request->taskDueDate;
        $taskStatusMsg = $request->taskStatusMsg;
        $taskColor = $request->taskColor;
        $taskPriority = $request->taskPriority;
        $taskCollabUserId = $request->taskCollabUserId; //not planning to implement this function yet
        $taskAssignedMemberId = $request->taskAssignedMemberId; //not planning to implement this function yet
        $taskDetailedDesc = $request->taskDetailedDesc;

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
                'task_detailedDesc' => $taskDetailedDesc,
                'task_userCreateID' => $userID,
                'task_startDate' => $taskStartDate,
                'task_dueDate' => $taskDueDate,
                'task_statusMsg' => $taskStatusMsg,
                'task_status' => '1',
                'task_color' => $taskColor,
                'task_priority' => $taskPriority,
            ]);

            if($request->hasfile('taskFiles')){
                $files = $request->file('taskFiles');
                foreach($files as $file){
                    //save the file into /public/upload/taskFiles/{taskID}
                    $taskFiles = $file->getClientOriginalName();
                    $filePath = 'upload/taskFiles/' . $task->id;
                    $fullFilePath = $file->move(public_path($filePath), $taskFiles);

                    // save the task's file dir into task_filePath
                    $task->task_filePath = $filePath;
                    $task->save();
                }
            }

            return [
                'message'=>'Task created.'
            ];
        }else{
            return [
                'message'=>'Please create new task in your own task list.'
            ];
        }
    }

    public function getTaskFilesByPath(Request $request){

        //variables that uses $request without validation
        $filePath = $request->filePath;
        $files = File::files(public_path(). '/' .$filePath);

        $fileDataArray = [];
        for($i=0; $i < count($files); $i++){
            $fileData = array(
                "fileName" => $files[$i]->getFileName(),
                "fileSize" => $files[$i]->getSize(),
                "filePath" => $files[$i]->getPath(),
            );
            $fileDataArray[$i] = $fileData;
        }

        return response($fileDataArray, 200);
    }

    public function downloadFileByPath(Request $request){

        //variables that uses $request without validation
        $fileName = $request->fileName;
        $filePath = $request->filePath;
        
        $getFilePath = public_path() . "/" . $filePath . "/" . $fileName;

        return response()->download($getFilePath, 200);
    }

    public function deleteFileByPath(Request $request){
        //variables that uses $request without validation
        $fileName = $request->fileName;
        $filePath = $request->filePath;

        $getFilePath = public_path() . "/" . $filePath . "/" . $fileName;

        File::delete($getFilePath);

        return [
            'message'=> 'File deleted successfully',
        ];
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
        $taskColor = $request->taskColor;
        $taskPriority = $request->taskPriority;
        $taskCollabUserId = $request->taskCollabUserId; //not planning to implement this function yet
        $taskAssignedMemberId = $request->taskAssignedMemberId; //not planning to implement this function yet
        $taskDetailedDesc = $request->taskDetailedDesc;

        $fields = $request->validate([
            'taskName' => ['required', 'string'],
            'taskDesc' => ['string'],
        ]);

        $task = Task::where('id', $taskID)->first();
        $task->task_name = $fields['taskName'];
        $task->task_desc = $fields['taskDesc'];
        $task->task_detailedDesc = $taskDetailedDesc;
        $task->task_startDate = $taskStartDate;
        $task->task_dueDate = $taskDueDate;
        $task->task_statusMsg = $taskStatusMsg;
        $task->task_color = $taskColor;
        $task->task_priority = $taskPriority;
        $task->save();

        return [
            'message'=>'Task updated.'
        ];
    }

    public function assignTask(Request $request){

        //variables that uses $request without validation
        $taskID = $request->taskID;
        $assignedUserID = $request->assignedUserID; // only can assign to one member
        $taskAssignedDate = $request->taskAssignedDate; // data received in epoch

        $task = Task::where('id', $taskID)->first();
        $taskAssignedMemberList = $task->task_assignedMemberID;
        $taskAssignedDateList = $task->task_assignedDate;

        if(strlen($taskAssignedMemberList) == 0){
            $taskAssignedMemberListNew = $assignedUserID;
        }else{
            $taskAssignedMemberListNew = $taskAssignedMemberList. ',' .$assignedUserID;
        }

        if(strlen($taskAssignedDateList) == 0){
            $taskAssignedDateListNew = $taskAssignedDate;
        }else{
            $taskAssignedDateListNew = $taskAssignedDateList. ',' .$taskAssignedDate;
        }

        $task->task_assignedMemberID = $taskAssignedMemberListNew;
        $task->task_assignedDate = $taskAssignedDateListNew;
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

    public function getCompletedTaskByTaskListID(Request $request){

        //variables that uses $request without validation
        $taskListID = $request->taskListID;

        $task = Task::where('task_taskListID', $taskListID)
                        ->where('task_status' , 0)->get();

        return response($task, 200);
    }

    public function deleteTaskByTaskID($id){
        
        $task = Task::where('id', $id)->first();

        $getFilePath = public_path() . "/" . $task->task_filePath;
        File::deleteDirectory($getFilePath);
        $task->delete();

        return [
            'message'=>'Task deleted.'
        ];
    }
}
