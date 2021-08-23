import Vue from 'vue'
import Vuex from 'vuex'
import createPersistedState from 'vuex-persistedstate';

Vue.use(Vuex)

export default new Vuex.Store({
    state: {
        userData: null,
    },
    plugins: [createPersistedState()],
    mutations: {
        saveUserData: (state, userData) => {
            state.userData = userData
        },
    },
    actions: {
        createUserSession({ commit }, userData){
            commit("saveUserData", userData)
        }
    }
})