% Copyright 2025 The MathWorks, Inc.
function generate_github_pipeline()
    op = pipegen.pipeline.Options();
    op.PipelineGenerationPackageRoot = "C:/Users/ahmedh/AppData/Roaming/MathWorks/MATLAB Add-Ons/PipelineGenerator@1.0.0";
    % op.RelativeProjectPath = "";
    op.RemoteBuildCacheName = "GitHub_Project_buildtool2";
    op.GeneratedPipelineFileName = ".github/workflows/build_pipeline.yml";
    
    op.ProcessName = "ci";
    % op.BuildPlanFilePath = "buildfile_original.m";
    op.Architecture = pipegen.pipeline.Architecture.RootDagJobs;
    % op.Architecture = pipegen.pipeline.Architecture.SerialJobs;
    % op.Architecture = pipegen.pipeline.Architecture.SerialJobsGroupPerTask;
    % op.Architecture = pipegen.pipeline.Architecture.SingleJob;
    % op.Architecture = pipegen.pipeline.Architecture.IndependentModelJobs;
    op.Platform = pipegen.pipeline.Platform.GitHub;
    op.TemplatePath = ".github/workflows/generic-job.yml";
    op.RunnerTags = "selfhosted_win_agents";
    op.StopOnStageFailure = true;
    op.ReportPath = "build_results/reports/finalReport";
    op.GenerateJUnitForProcess = false;
    
    op.ArtifactServiceMode = 'azure_blob';         % network/jfrog/s3/azure_blob
    % op.NetworkStoragePath = '<Network storage path>';
    % op.ArtifactoryUrl = '<JFrog Artifactory url>';
    % op.ArtifactoryRepoName = '<JFrog Artifactory repo name>';
    % op.S3BucketName = '<AWS S3 bucket name>';
    % op.S3AwsAccessKeyID = '<AWS S3 access key id>';
    op.AzContainerName = 'padvblobcontainer';
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