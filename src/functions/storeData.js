import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
    state: {
        userData: [],
    },
    mutations: {
        saveUserData: (state, userData) => {
            state.userData.push(userData)
        },
    },
    actions: {
        createUserSession({ commit }, userData){
            commit("saveUserData", userData)
        }
    }
})