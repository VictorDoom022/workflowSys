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

Route::get('users/{id}', [App\Http\Controllers\Auth\LoginController::class, 'getUserData']);
Route::post('register', [App\Http\Controllers\Auth\RegisterController::class, 'register']);
Route::post('login', [App\Http\Controllers\Auth\LoginController::class, 'login']);

Route::group(['middleware' => 'auth:sanctum'], function(){
    //All secure URL's
    Route::post('logout', [App\Http\Controllers\Auth\LoginController::class, 'logout']);
});
