Get-AzSqlElasticPoolActivity `
                    -ResourceGroupName placeholder `
                    -ServerName placeholder `
                    -ElasticPoolName placeholder -ErrorAction Stop `
                | sort StartTime -Descending

"stoping now"

Stop-AzSqlElasticPoolActivity `
-ElasticPoolName placeholder `
-ResourceGroupName placeholder `
-ServerName placeholder `
-OperationId placeholder
