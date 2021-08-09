<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ToDo extends Model
{
    use HasFactory;

    protected $table = 'todo';

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'todo_userID',
        'todo_name',
        'todo_desc',
        'todo_startDate',
        'todo_dueDate',
        'todo_statusMsg',
        'todo_status'
    ];
}
