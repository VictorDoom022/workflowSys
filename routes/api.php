<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:api')->get('/user', function (Request $request) {
    return $request->user();
});

Route::post('register', [App\Http\Controllers\Auth\RegisterController::class, 'register']);
Route::post('login', [App\Http\Controllers\Auth\LoginController::class, 'login']);
Route::group(['middleware' => 'auth:sanctum'], function(){
    //All secure URL's
    //Dashboard routes
    Route::get('data/getUserTaskOverview', [App\Http\Controllers\DashboardController::class, 'getUserTaskOverview']);
    Route::get('data/getUserActiveTask', [App\Http\Controllers\DashboardController::class, 'getUserActiveTask']);
    Route::get('data/getHighPriorityTask', [App\Http\Controllers\DashboardController::class, 'getHighPriorityTask']);
    Route::get('data/getAssigendToUserTask', [App\Http\Controllers\DashboardController::class, 'getAssigendToUserTask']);
    Route::get('data/getTaskLastActivityGraphData', [App\Http\Controllers\DashboardController::class, 'getTaskLastActivityGraphData']);
    Route::get('data/getCompletedTaskGraphData', [App\Http\Controllers\DashboardController::class, 'getCompletedTaskGraphData']);

    //User routes
    Route::post('logout', [App\Http\Controllers\Auth\LoginController::class, 'logout']);
    Route::get('users/{id}', [App\Http\Controllers\UserController::class, 'getUserByID']);
    Route::get('users', [App\Http\Controllers\UserController::class, 'getAllUserData']);
    Route::post('users/delete/{id}', [App\Http\Controllers\UserController::class, 'deleteUser']);
    Route::post('users/setUserStatus', [App\Http\Controllers\UserController::class, 'setUserStatus']);
    Route::post('users/toggleUserBan/{id}', [App\Http\Controllers\UserController::class, 'toggleUserBan']);
    Route::post('users/uploadProfilePicture', [App\Http\Controllers\UserController::class, 'uploadProfilePicture']);
    Route::post('users/getUserProfilePictureByUserID', [App\Http\Controllers\UserController::class, 'getUserProfilePictureByUserID']);
    Route::post('users/changeUserPassword', [App\Http\Controllers\UserController::class, 'changeUserPassword']);

    //Group routes
    Route::post('createGroup', [App\Http\Controllers\GroupController::class, 'createGroup']);
    Route::post('group/userID/{userID}', [App\Http\Controllers\GroupController::class, 'getUserJoinedGroup']);
    Route::post('group/joinGroup', [App\Http\Controllers\GroupController::class, 'joinGroup']);
    Route::post('group/getGroupDetailByGroupUserID', [App\Http\Controllers\GroupController::class, 'getGroupDetailByGroupUserID']);
    Route::post('group/getGroupTeamByGroupID', [App\Http\Controllers\GroupController::class, 'getGroupTeamByGroupID']);
    Route::post('group/getGroupUserByGroupID', [App\Http\Controllers\GroupController::class, 'getGroupUserByGroupID']);
    Route::post('group/getGroupNonAdminUser', [App\Http\Controllers\GroupController::class, 'getGroupNonAdminUser']);
    Route::post('group/getGroupAdminUser', [App\Http\Controllers\GroupController::class, 'getGroupAdminUser']);
    Route::post('group/setMemberAsAdmin', [App\Http\Controllers\GroupController::class, 'setMemberAsAdmin']);
    Route::post('group/removeMemberFromGroupAdmin', [App\Http\Controllers\GroupController::class, 'removeMemberFromGroupAdmin']);
    Route::post('group/deleteGroup/{groupID}', [App\Http\Controllers\GroupController::class, 'deleteGroup']);
    Route::post('group/renameGroup', [App\Http\Controllers\GroupController::class, 'renameGroup']);
    Route::post('group/checkIsUserAdminByGroupID', [App\Http\Controllers\GroupController::class, 'checkIsUserAdminByGroupID']);
    Route::post('group/checkIsUserAdminByTeamID', [App\Http\Controllers\GroupController::class, 'checkIsUserAdminByTeamID']);
    Route::post('group/removeMemberFromGroup', [App\Http\Controllers\GroupController::class, 'removeMemberFromGroup']);
    Route::post('group/generateNewGroupJoinCode', [App\Http\Controllers\GroupController::class, 'generateNewGroupJoinCode']);

    //Team routes
    Route::post('team/getTeamID', [App\Http\Controllers\TeamController::class, 'getTeamDetail']);
    Route::post('team/createTeam', [App\Http\Controllers\TeamController::class, 'createTeam']);
    Route::post('team/getTeamUserDiff', [App\Http\Controllers\TeamController::class, 'getUserNotJoinedTeam']);
    Route::post('team/getTeamUser', [App\Http\Controllers\TeamController::class, 'getUserJoinedTeam']);
    Route::post('team/addMemberToTeam', [App\Http\Controllers\TeamController::class, 'addMemberToTeam']);
    Route::post('team/removeMemberFromTeam', [App\Http\Controllers\TeamController::class, 'removeMemberFromTeam']);
    Route::post('team/deleteTeam', [App\Http\Controllers\TeamController::class, 'deleteTeam']);
    Route::post('team/renameTeam', [App\Http\Controllers\TeamController::class, 'renameTeam']);
    //Task routes
    Route::post('task/createTask', [App\Http\Controllers\TaskController::class, 'createTask']);
    Route::post('task/getTaskByTaskListID', [App\Http\Controllers\TaskController::class, 'getTaskByTaskListID']);
    Route::post('task/getTaskByID', [App\Http\Controllers\TaskController::class, 'getTaskByID']);
    Route::post('task/updateTask', [App\Http\Controllers\TaskController::class, 'updateTask']);
    Route::post('task/assignTask', [App\Http\Controllers\TaskController::class, 'assignTask']);
    Route::post('task/taskAssignedToUser', [App\Http\Controllers\TaskController::class, 'taskAssignedToUser']);
    Route::post('task/changeTaskStatus', [App\Http\Controllers\TaskController::class, 'changeTaskStatus']);
    Route::post('task/getCompletedTaskByTaskListID', [App\Http\Controllers\TaskController::class, 'getCompletedTaskByTaskListID']);
    Route::post('task/deleteTaskByTaskID/{id}', [App\Http\Controllers\TaskController::class, 'deleteTaskByTaskID']);
    Route::post('task/getTaskFilesByPath', [App\Http\Controllers\TaskController::class, 'getTaskFilesByPath']);
    Route::post('task/downloadFileByPath', [App\Http\Controllers\TaskController::class, 'downloadFileByPath']);
    Route::post('task/deleteFileByPath', [App\Http\Controllers\TaskController::class, 'deleteFileByPath']);
    //Todo routes
    Route::post('todo/createTodo', [App\Http\Controllers\ToDoController::class, 'createTodo']);
    Route::post('todo/getTodoByID', [App\Http\Controllers\ToDoController::class, 'getTodoByID']);
    Route::post('todo/getToDoByUserID', [App\Http\Controllers\ToDoController::class, 'getToDoByUserID']);
    Route::post('todo/updateTodo', [App\Http\Controllers\ToDoController::class, 'updateTodo']);
    Route::post('todo/deleteTodoById/{id}', [App\Http\Controllers\ToDoController::class, 'deleteTodoById']);
    Route::post('todo/changeTodoStatus', [App\Http\Controllers\ToDoController::class, 'changeTodoStatus']);
    Route::post('todo/getToDoArchivedByUserID', [App\Http\Controllers\ToDoController::class, 'getToDoArchivedByUserID']);
    //Comment routes
    Route::post('comment/createComment', [App\Http\Controllers\CommentController::class, 'createComment']);
    Route::post('comment/getCommentByTaskID', [App\Http\Controllers\CommentController::class, 'getCommentByTaskID']);
    //Chat routes
    Route::post('chat/sendMessage', [App\Http\Controllers\ChatController::class, 'sendMessage']);
    Route::post('chat/getUserChat', [App\Http\Controllers\ChatController::class, 'getUserChat']);
    Route::post('chat/getUserChatHistory', [App\Http\Controllers\ChatController::class, 'getUserChatHistory']);
});
