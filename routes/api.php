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
    //User routes
    Route::post('logout', [App\Http\Controllers\Auth\LoginController::class, 'logout']);
    Route::get('users/{id}', [App\Http\Controllers\UserController::class, 'getUserByID']);
    Route::get('users', [App\Http\Controllers\UserController::class, 'getAllUserData']);
    Route::post('users/delete/{id}', [App\Http\Controllers\UserController::class, 'deleteUser']);
    Route::post('users/setUserStatus', [App\Http\Controllers\UserController::class, 'setUserStatus']);
    Route::post('users/toggleUserBan/{id}', [App\Http\Controllers\UserController::class, 'toggleUserBan']);
    //Group routes
    Route::post('createGroup', [App\Http\Controllers\GroupController::class, 'createGroup']);
    Route::post('group/userID/{userID}', [App\Http\Controllers\GroupController::class, 'getUserJoinedGroup']);
    Route::post('group/joinGroup', [App\Http\Controllers\GroupController::class, 'joinGroup']);
    Route::post('group/getGroupDetailByGroupUserID', [App\Http\Controllers\GroupController::class, 'getGroupDetailByGroupUserID']);
    Route::post('group/getGroupTeamByGroupID', [App\Http\Controllers\GroupController::class, 'getGroupTeamByGroupID']);
    Route::post('group/getGroupUserByGroupID', [App\Http\Controllers\GroupController::class, 'getGroupUserByGroupID']);
    Route::post('group/getGroupNonAdminUser', [App\Http\Controllers\GroupController::class, 'getGroupNonAdminUser']);
    Route::post('group/setMemberAsAdmin', [App\Http\Controllers\GroupController::class, 'setMemberAsAdmin']);
    //Team routes
    Route::post('team/getTeamID', [App\Http\Controllers\TeamController::class, 'getTeamDetail']);
    Route::post('team/createTeam', [App\Http\Controllers\TeamController::class, 'createTeam']);
    Route::post('team/getTeamUserDiff', [App\Http\Controllers\TeamController::class, 'getUserNotJoinedTeam']);
    Route::post('team/getTeamUser', [App\Http\Controllers\TeamController::class, 'getUserJoinedTeam']);
    Route::post('team/addMemberToTeam', [App\Http\Controllers\TeamController::class, 'addMemberToTeam']);
    Route::post('team/removeMemberFromTeam', [App\Http\Controllers\TeamController::class, 'removeMemberFromTeam']);
    Route::post('team/deleteTeam', [App\Http\Controllers\TeamController::class, 'deleteTeam']);
});
