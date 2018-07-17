// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"
import Vue from "vue"
import VueResource from 'vue-resource'
import _ from 'underscore'

Vue.use(VueResource)

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

feud_vue = new Vue({
  el: "#feud_admin",
  data: {
    activeUser: 1,
    userList: [
      { id: 1, name: "Admin" },
      { id: 2, name: "User 1" },
      { id: 3, name: "User 2" },
      { id: 4, name: "User 3" },
      { id: 5, name: "User 4" }
    ],
    questionDB: [],
    searchText: "",
    idxQuestions: {},
    formData: {
      id: 0,
      text: "",
      answer: ""
    },
    upvotedAnswers: []
  },
  http: {},
  created: function() {
    console.log("Created App")
    var _self = this;
    this.changeUser(1);
    this.idxQuestions = {};
    this.$http.get("/api/questions").then(function(res) {
      _self.questionDB = res.body.data;
      _.forEach(_self.questionDB, function(q, i) {
        _self.idxQuestions[q.id] = q;
      });
    });
  },
  methods: {
    changeUser: function(userID) {
      this.activeUser = userID;
      this.getUserVotes();
    },
    getUserVotes: function() {
      var _self = this;
      this.$http
        .post("/api/votes", { userID: this.activeUser })
        .then(function(res) {
          console.log(res);
          _self.upvotedAnswers = res.body;
        });
    },
    checkVote: function(answer) {
      return this.upvotedAnswers.indexOf(answer.id) != -1 ? "fas" : "far";
    },
    addNewQuestion: function () {

      this.formData.id = 0;
      this.formData.text = "";
      this.formData.answer = "";
    },
    editQuestion: function(question) {
      this.formData.id = question.id;
      this.formData.text = question.text;
      this.formData.answer = "";
    },
    saveQuestion: function() {
      var _self = this;
      this.$http
        .post("/api/questions", {
          question:{
            id: this.formData.id,
            text: this.formData.text,
            user_id: this.activeUser
          }
        })
        .then(function(res) {
          var result = res.body;
          if (_self.idxQuestions.hasOwnProperty(result.data.id)){
            for (var i in result) {
              _self.idxQuestions[result.data.id][i] = result.data;
            }
          } else {
            _self.questionDB.push(result.data);
            var question = _self.questionDB[_self.questionDB.length-1];
            _self.idxQuestions[result.data.id] = question;
            _self.editQuestion(question);

          }
        });
    },
    getQuestionAnswers: function() {
      if (this.idxQuestions.hasOwnProperty(this.formData.id))
        return this.idxQuestions[this.formData.id].answers;
      return [];
    },
    addAnswer: function() {
      if (this.formData.text == "") return false;
      var _self = this;
      this.$http
        .post("/api/answers", {
          answer: {
            question_id: this.formData.id,
            text: this.formData.answer,
            user_id: this.activeUser
          }
        })
        .then(function(res) {
          var result = res.body.data;

          _self.idxQuestions[_self.formData.id]["answers"].push(result);
          _self.upvotedAnswers.push(result.id);
          _self.formData.answer = "";
        });
    },
    toggleVote: function(answer) {
      var _self = this;
      var wasUpvoted = this.upvotedAnswers.indexOf(answer.id) != -1;
      var endpoint = wasUpvoted ? "unvote" : "vote";
      this.$http
        .post("/api/" + endpoint, {
          answer_id: answer.id,
          userID: this.activeUser
        })
        .then(function(res) {
          var result = res.body;
          console.log(result);
          for (var i in result) {
            answer[i] = result[i];
          }

          if (wasUpvoted) {
            _self.upvotedAnswers.splice(_self.upvotedAnswers.indexOf(answer.id),1);
          } else {  
            _self.upvotedAnswers.push(answer.id)
          }
        });
    }
  }
});
