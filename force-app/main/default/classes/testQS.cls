public class testQS {
	public static copado__Deployment_Flow__c getInProgressPipeline() {
        copado__Deployment_Flow__c result;

        try {
            for (copado__Deployment_Flow__c pipeline : [select id, cmcSf__Initialization_Data__c from copado__Deployment_Flow__c]) {
                if (isQuickStartInProgress(pipeline)) {
                    result = pipeline;
                    break;
                }
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return result;
    }
    
    private static Boolean isQuickStartInProgress(copado__Deployment_Flow__c pipeline) {
        if (String.isBlank(pipeline?.cmcSf__Initialization_Data__c)) {
            return false;
        } else {
            Details initializationData = (Details) JSON.deserialize(pipeline.cmcSf__Initialization_Data__c, Details.class);
            if (initializationData?.quickStart == null) {
                return false;
            }
            for (Details.QuickStartStep step : initializationData?.quickStart?.quickStartSteps) {
                if (step.isActive) {
                    return true;
                }
            }
            return false;
        }
    }
}