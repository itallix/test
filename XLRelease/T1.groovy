// Exported from:        http://piter.local:5516/#/templates/Release6b86d7241149419e852cd814154b91e6/releasefile
// XL Release version:   8.1.0-SNAPSHOT
// Date created:         Mon Aug 27 14:10:53 CEST 2018

xlr {
  template('T1') {
    scheduledStartDate Date.parse("yyyy-MM-dd'T'HH:mm:ssZ", '2018-08-24T09:00:00+0200')
    abortOnFailure true
    scriptUsername 'admin'
    scriptUserPassword '{b64}YFKOzMTEICsqFJ592l2FbQ=='
    phases {
      phase('New Phase') {
        tasks {
          manual('T1') {
            taskFailureHandlerEnabled true
          }
          manual('T2') {
            
          }
          manual('T3') {
            
          }
        }
      }
    }
    teams {
      team('Release Admin') {
        permissions 'release#edit_precondition', 'release#edit', 'release#reassign_task', 'release#edit_security', 'release#view', 'release#lock_task', 'release#start', 'release#edit_blackout', 'template#view', 'release#edit_failure_handler', 'release#abort', 'release#edit_task'
      }
      team('Template Owner') {
        members 'admin'
        permissions 'template#edit', 'template#lock_task', 'template#view', 'template#edit_triggers', 'template#edit_precondition', 'template#edit_security', 'template#create_release', 'template#edit_failure_handler'
      }
    }
  }
}