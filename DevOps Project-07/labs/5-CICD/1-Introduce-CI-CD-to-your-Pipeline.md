# Begin CI/CD with Pipeline Trigger for automatic pipeline runs

In Azure DevOps, you can use triggers to run pipelines automatically. In this lab we will set a trigger to automatically run the pipeline when there has been a change to the main/master branch


1. You may have noticed prior changes to this branch didn't automatically run the pipeline. This is because the pipeline trigger is set to none. 

`trigger: none`


2. Update pipeline with trigger below - this will run the pipeline each time a change has been made to the main/master branch. *( Rename main/master as per your branch naming)*

```
trigger:
  batch: true 
  branches:
    include:
      - master
```

3. Edit your Azure DevOps pipeline to run this [Pipeline](labs/5-CICD/pipelines/lab5pipeline.yaml#L3-L7)
