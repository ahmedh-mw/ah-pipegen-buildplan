% Copyright 2025 The MathWorks, Inc.
function generate_github_pipeline()
    op = pg.pipeline.Options();
    op.PipelineGenerationPackageRoot = "D:/repos/gh/pipeline_generator_porting";
    % op.RelativeProjectPath = "";
    op.RemoteBuildCacheName = "GitHub_Project_buildtool";
    op.GeneratedPipelineFileName = ".github/workflows/build_pipeline.yml";
    
    op.ProcessName = "ci";
    op.BuildPlanFilePath = "buildfile_ci.m";
    % op.Architecture = pg.pipeline.Architecture.FullDAGJobs;
    op.Architecture = pg.pipeline.Architecture.SerialJobs;
    op.Platform = pg.pipeline.Platform.GitHub;
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

    matlab.buildtool.generators.generatePipeline(op);
end