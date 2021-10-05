<template>

</template>

<script>
import Vue from 'vue'

export default {
    props: ['fileName', 'taskFilePath', 'userToken'],
    mounted(){
        this.downloadFile()
    },
    methods: {
        downloadFile(){
            Vue.axios({
                url: '/task/downloadFileByPath',
                method: 'POST',
                headers: {
                    Authorization : 'Bearer ' + JSON.parse(this.userToken),
                    'Content-Type': 'application/json',
                },
                data: {
                    fileName : JSON.parse(this.fileName),
                    filePath : JSON.parse(this.taskFilePath),
                },
            }).then((response) => {
                const url = window.URL.createObjectURL(new Blob([response.data]));
                const link = document.createElement('a');
                link.href = url;
                link.setAttribute('download', JSON.parse(this.fileName));
                document.body.appendChild(link);
                link.click();
            })
        },
    }
}
</script>

<style>

</style>