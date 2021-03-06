crds-code-generation-tools
=========================

`crds-code-generation-tools` is a tool which helps to provide CRDs template and generate code relevant with your CRDs(such as clientset and so on) using [code-generator](https://github.com/kubernetes/code-generator) efficiently.

## Usage

### Params

```
hack/crds-code-generation.sh GroupName GroupPackage Version Kind Plural(eg: duyanghao.example.com duyanghao v1 Project projects)
```

![](images/kubernetes-group-version.png)

* GroupName: Resource Group of CRDs(eg: `duyanghao.example.com`)
* GroupPackage: Generated group package directory, which is normal the prefix of `GroupName`(eg: `duyanghao`)
* Version: Resource Version of CRDs, relevant with `GroupName`(eg: `v1`)
* Kind: Resource Kind of CRDs, which is what you want to create in Kubernetes and begins with a capital letter(eg: `Project`)
* Plural: The plural of CRDs(eg: `projects`)

### Steps

Generating a CRD with `crds-code-generation-tools` is a simple task that involves a few steps as below:

#### STEP 1 - Generate CRDs

```bash
# execute crds-code-generation.sh
$ git clone https://github.com/duyanghao/crds-code-generation-tools.git && cd crds-code-generation-tools
$ bash hack/crds-code-generation.sh duyanghao.example.com duyanghao v1 Project projects
# CRDs template will be listed like below:
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

#### STEP 2 - Copy CRDs to your own project

```bash
# copy CRDs to your own project
$ grep -rl "github.com/duyanghao/crds-code-generation-tools" ./ | xargs sed -i '' 's/github.com\/duyanghao\/crds-code-generation-tools/your_project/g'
$ cp -r artifacts your_project/artifacts
$ cp -r hack your_project/hack
$ cp -r pkg/apis your_project/pkg/apis
```
 
#### STEP 3 - Edit your own CRDs

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

#### STEP 4 - Generate code relevant with your CRDs(such as clientset and so on)

```bash
# generate code with update-codegen.sh
$ bash hack/update-codegen.sh
Generating deepcopy funcs
Generating clientset for duyanghao:v1 at github.com/duyanghao/crds-code-generation-tools/generated/clientset
Generating listers for duyanghao:v1 at github.com/duyanghao/crds-code-generation-tools/generated/listers
Generating informers for duyanghao:v1 at github.com/duyanghao/crds-code-generation-tools/generated/informers
$ tree -L 2 generated
generated
├── clientset
│   └── versioned
├── informers
│   └── externalversions
└── listers
    └── duyanghao
```

## Refs

* [crd-code-generation](https://github.com/openshift-evangelists/crd-code-generation)
