package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"os/exec"

	"github.com/mikefarah/yq/v4/pkg/yqlib"
)

// Define the paths of the configuration files
const agentConfigPath = "/etc/otel/agent_config.yaml"
const collectorConfigPath = "/etc/otel/collector/splunk-otel-collector.conf"

// Define the structure of the service configuration file
type ServiceConfig struct {
	Name       string `yaml:"name"`
	Receiver   string `yaml:"receiver"`
	Exporters  []string `yaml:"exporters"`
	Processors []string `yaml:"processors"`
}

func main() {
	// Read the service configuration file
	serviceConfig, err := readServiceConfig()
	if err != nil {
		log.Fatalf("Failed to read service config: %v", err)
	}

	// Modify the agent config file
	err = modifyAgentConfig(serviceConfig)
	if err != nil {
		log.Fatalf("Failed to modify agent config: %v", err)
	}

	// Modify the collector config file
	err = modifyCollectorConfig(serviceConfig)
	if err != nil {
		log.Fatalf("Failed to modify collector config: %v", err)
	}
}

func readServiceConfig() (*ServiceConfig, error) {
	// Read the service configuration file
	serviceConfigBytes, err := ioutil.ReadFile("/path/to/service/config.yaml")
	if err != nil {
		return nil, fmt.Errorf("Failed to read service config file: %v", err)
	}

	// Unmarshal the service configuration into a struct
	serviceConfig := &ServiceConfig{}
	err = yaml.Unmarshal(serviceConfigBytes, serviceConfig)
	if err != nil {
		return nil, fmt.Errorf("Failed to unmarshal service config: %v", err)
	}

	return serviceConfig, nil
}

func modifyAgentConfig(serviceConfig *ServiceConfig) error {
	// Use yq to modify the agent config file
	command := exec.Command("yq", "w", "-i", agentConfigPath, fmt.Sprintf("services.%s.receivers.%s.exporters", serviceConfig.Name, serviceConfig.Receiver), serviceConfig.Exporters)
	output, err := command.CombinedOutput()
	if err != nil {
		return fmt.Errorf("Failed to modify agent config: %v, %s", err, output)
	}

	return nil
}

func modifyCollectorConfig(serviceConfig *ServiceConfig) error {
	// Use yq to modify the collector config file
	command := exec.Command("yq", "w", "-i", collectorConfigPath, fmt.Sprintf("[[inputs.logconfig]]\n\tname=%s\n\tdestination=%s\n", serviceConfig.Name, serviceConfig.Receiver))
	output, err := command.CombinedOutput()
	if err != nil {
		return fmt.Errorf("Failed to modify collector config: %v, %s", err, output)
	}

	return nil
}
