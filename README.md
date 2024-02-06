OKDerators
===
An opinionated catalog of operators adapted for [OKD](https://okd.io)

## What is OKD?
OKD is a community distribution of [Kubernetes](https://kubernetes.io/) (K8s), a collection of software and design patterns to operate applications at scale.

OKD shares many of the same underlying cluster components as the commerical distribution [RedHat OpenShift](https://www.redhat.com/en/technologies/cloud-computing/openshift).

## What are Operators?
The [Operator pattern](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/) is the concept of running "meta" software within your cluster to manage your applications and supporting components. 


For example, you as a cluster operator may provision a `OpensourceDatabaseSoftware` (an operator-defined [Custom Resource](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/)), and the operator would take care of provisioning the underlying resources (Deployments, ConfigMap, Secrets, Pods, etc) on your behalf, based on the configuration you provide.


Within OKD, we use a suite of tools called [Operator Framework](https://operatorframework.io/) to manage operators within the cluster (an operator for operators). With Operator Framework we can access operators from central catalogs (such as this one) and install them within our cluster.

## So what's in this catalog?
This catalog contains a curated selection of operators.

Kubernetes, by nature, has a lot of different ways to accomplish the same thing (such as data storage, CI/CD pipelines, log management). The choice can be overwhelming for administrators, and can create challenges integrating them together and into OKD.

Within RedHat OpenShift, the private catalog contains distributions of opensource projects to suit a variety of standard workflow requirements. For example, [OpenShift Pipelines](https://docs.openshift.com/pipelines/latest/about/about-pipelines.html) is an OpenShift-tuned distribution of the opensource project [Tekton](https://tekton.dev/).

Similary, this public catalog contains packaged solutions to common usecases, based off opensource projects.

In many cases we will use the same code and packaging that adapts operators for OpenShift but altered to remove trademarked branding related to RedHat.

## Why do you need OKD-adapted operators/applications?
Compared to many other Kubernetes distributions, OKD has additional security restrictions, assumptions and fetures that mean an operator or application that would work "out of the box" on a more vanilla Kubernetes distribution, does not function on OKD. For example, additional security profiles may need to be applied, or MachineConfigs applied to add node features.

## Contributing
This is a test project and we are seeking contributors. Please join the OKD Development Working Group or reach out on Slack in #openshift-users.

