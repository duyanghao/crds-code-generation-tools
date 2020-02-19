crds-code-generation-tools
=========================

`crds-code-generation-tools` is a tool which provides CRD template and generates code relevant with your CRDs(such as clientset and so on) using [code-generator](https://github.com/kubernetes/code-generator).

## Usage

Generating a CRD with `crds-code-generation-tools` is a simple task that involves a few steps as below:

* 1.Generate CRD
  ```bash
  # execute crds-code-generation.sh
  $ git clone https://github.com/duyanghao/crds-code-generation-tools.git && crds-code-generation-tools
  $ bash hack/crds-code-generation.sh
  Usage:
  hack/crds-code-generation.sh, GroupName GroupPackage Version Kind Plural(eg: duyanghao.example.com duyanghao v1 Project projects)
  $ bash hack/crds-code-generation.sh duyanghao.example.com duyanghao v1 Project projects
  # CRD will list like below:
  pkg
  └── apis
      └── duyanghao
          ├── register.go
          └── v1
              ├── doc.go
              ├── register.go
              └── types.go 
  artifacts
  └── crd.yaml
  ``` 
* 2.Edit your own CRDs
  ```bash
  # Complete the Spec and Status fields if necessary 
  $ cat pkg/apis/duyanghao/v1/types.go
  package v1
  
  import (
  	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
  )
  
  // +genclient
  // +genclient:noStatus
  // +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object
  
  type Project struct {
  	metav1.TypeMeta   `json:",inline"`
  	metav1.ObjectMeta `json:"metadata,omitempty"`
  
  	Spec ProjectSpec `json:"spec"`
  }
  
  // ProjectSpec is the spec for a Project resource
  type ProjectSpec struct {
  }
  
  // +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object
  
  // ProjectList is a list of Project resources
  type ProjectList struct {
  	metav1.TypeMeta `json:",inline"`
  	metav1.ListMeta `json:"metadata"`
  
  	Items []Project `json:"items"`
  }
  ```
 * 3.Copy CRDs to your project
  ```bash
  # copy CRD to your project
  $ cp -r crds-code-generation-tools your_project
  # generate your own project
  $ grep -rl "github.com/duyanghao/crds-code-generation-tools" ./ | xargs sed -i '' 's/github.com\/duyanghao\/crds-code-generation-tools/your_project/g'
  ```
  * 4.Generate code relevant with your CRD(such as clientset and so on)
  ```bash
  # generate code with update-codegen.sh
  $ bash hack/update-codegen.sh
  ```

## Refs

* [crd-code-generation](https://github.com/openshift-evangelists/crd-code-generation)
