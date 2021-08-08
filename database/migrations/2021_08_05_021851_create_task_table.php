<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateTaskTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('task', function (Blueprint $table) {
            $table->id();
            $table->string('task_taskListID');
            $table->string('task_teamID');
            $table->string('task_name');
            $table->string('task_desc');
            $table->string('task_userCreateID');
            $table->string('task_assignedMemberID');
            $table->longText('task_assignedDate');
            $table->string('task_startDate');
            $table->string('task_dueDate');
            $table->string('task_statusMsg');
            $table->integer('task_status');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('task');
    }
}
