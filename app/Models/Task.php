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
        'task_teamID',
        'task_name',
        'task_desc',
        'task_detailedDesc',
        'task_userCreateID',
        'task_assignedMemberID',
        'task_assignedDate',
        'task_startDate',
        'task_dueDate',
        'task_statusMsg',
        'task_status',
        'task_color',
        'task_priority',
        'task_filePath',
    ];
}
