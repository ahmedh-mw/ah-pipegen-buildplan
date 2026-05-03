% Copyright 2025 The MathWorks, Inc.
% generate_jenkins_pipeline(".build")
function generate_jenkins_pipeline(pipelineGenDirectory)
    if nargin < 1
        pipelineGenDirectory = string(getenv('MW_PIPELINE_GEN_DIRECTORY'));
    end
    
    op = pipegen.pipeline.Options();
    op.PipelineGenerationPackageRoot = string(getenv('MW_PIPELINE_GENERATION_PACKAGE_ROOT'));
    op.RelativeProjectPath = string(getenv('MW_RELATIVE_PROJECT_PATH'));
    op.RemoteBuildCacheName = string(getenv('MW_REMOTE_BUILD_CACHE_NAME'));
    op.GeneratedPipelineFileName = fullfile(pipelineGenDirectory, "build_pipeline.groovy");
    
    op.ProcessName = "ci";
    % op.BuildPlanFilePath = "buildfile_ci.m";
    % op.BuildPlanFilePath = "buildfile_original.m";
    % op.Architecture = pipegen.pipeline.Architecture.SerialJobs;
    % op.Architecture = pipegen.pipeline.Architecture.RootDagJobs;
    op.Architecture = pipegen.pipeline.Architecture.SerialJobsGroupPerTask;
    % op.Architecture = pipegen.pipeline.Architecture.IndependentModelJobs;
    op.Platform = pipegen.pipeline.Platform.Jenkins;
    % op.TemplatePath = "templates/generic-job.yml";
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