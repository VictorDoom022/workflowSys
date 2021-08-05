<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Task extends Model
{
    use HasFactory;

    protected $table = 'task';

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'task_taskListID',
        'task_name',
        'task_userCreateID',
        'task_collabUserID',
        'task_assignedMemberID',
        'task_startDate',
        'task_dueDate',
        'task_status',
    ];
}
