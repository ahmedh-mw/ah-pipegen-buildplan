% Copyright 2026 The MathWorks, Inc.

function generate_azure_pipeline()
    op = pipegen.pipeline.Options();
    op.PipelineGenerationPackageRoot = "C:/Users/ahmedh/AppData/Roaming/MathWorks/MATLAB Add-Ons/PipelineGenerator@1.0.0";
    % op.RelativeProjectPath = "";
    op.RemoteBuildCacheName = "Pipegen_Azure_buildtool";
    op.GeneratedPipelineFileName = ".azure/workflows/build_pipeline.yml";
    
    op.ProcessName = "ci";
    % op.BuildPlanFilePath = "buildfile_original.m";
    op.Architecture = pipegen.pipeline.Architecture.RootDagJobs;
    % op.Architecture = pipegen.pipeline.Architecture.SerialJobs;
    % op.Architecture = pipegen.pipeline.Architecture.SerialJobsGroupPerTask;
    % op.Architecture = pipegen.pipeline.Architecture.SingleJob;
    % op.Architecture = pipegen.pipeline.Architecture.IndependentModelJobs;
    op.Platform = pipegen.pipeline.Platform.AzureDevOps;
    op.TemplatePath = "templates/generic-job.yml";
    op.RunnerTags = "padv_win_agents";
    op.StopOnStageFailure = true;
    op.ReportPath = "build_results/reports/finalReport";
    op.GenerateJUnitForProcess = false;
    
    op.ArtifactServiceMode = 'jfrog';         % network/jfrog/s3/azure_blob
    % op.NetworkStoragePath = '<Network storage path>';
    % op.NetworkStoragePath = "C:\artifactManagement";
    % op.ArtifactoryUrl = '<JFrog Artifactory url>';
    op.ArtifactoryUrl = 'http://mathworks-v4rgb:8082/artifactory';
    % op.ArtifactoryRepoName = '<JFrog Artifactory repo name>';
    op.ArtifactoryRepoName = 'padv-bslcicd';
    % op.S3BucketName = '<AWS S3 bucket name>';
    % op.S3AwsAccessKeyID = '<AWS S3 access key id>';
    % op.AzContainerName = 'padvblobcontainer';
    % op.RunnerType = "container";          % default/container
    % op.ImageTag = '<Docker Image full name>';
    % op.ImageArgs = "<Docker container arguments>";
    
    % Docker image settings
    op.UseMatlabPlugin = false;
    % op.MatlabLaunchCmd = "xvfb-run -a matlab -batch"; 
    % op.MatlabStartupOptions = "";
    % op.AddBatchStartupOption = false;
    
    pipegen.mbt.generators.generatePipeline(op);
end