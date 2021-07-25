<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class UserDetail extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('userDetail', function(Blueprint $table) {
            $table->integer('userDetail_id');
            $table->string('userDetail_joinedGroupID')->defaultValue('[]');
            $table->string('userDetail_status')->defaultValue('active');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('userDetail');
    }
}
