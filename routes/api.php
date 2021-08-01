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
    Route::post('logout', [App\Http\Controllers\Auth\LoginController::class, 'logout']);
    Route::get('users/{id}', [App\Http\Controllers\UserController::class, 'getUserByID']);
    Route::get('users', [App\Http\Controllers\UserController::class, 'getAllUserData']);
    Route::post('users/delete/{id}', [App\Http\Controllers\UserController::class, 'deleteUser']);
    Route::post('users/setUserStatus', [App\Http\Controllers\UserController::class, 'setUserStatus']);
    Route::post('users/toggleUserBan/{id}', [App\Http\Controllers\UserController::class, 'toggleUserBan']);
    Route::post('createGroup', [App\Http\Controllers\GroupController::class, 'createGroup']);
    Route::post('group/userID/{userID}', [App\Http\Controllers\GroupController::class, 'getUserJoinedGroup']);
    Route::post('group/joinGroup', [App\Http\Controllers\GroupController::class, 'joinGroup']);
    Route::post('group/getGroupID', [App\Http\Controllers\GroupController::class, 'getGroupDetail']);
    Route::post('team/getTeamID', [App\Http\Controllers\TeamController::class, 'getTeamDetail']);
    Route::post('team/createTeam', [App\Http\Controllers\TeamController::class, 'createTeam']);
    Route::post('team/getTeamUserDiff', [App\Http\Controllers\TeamController::class, 'getUserNotJoinedTeam']);
});
