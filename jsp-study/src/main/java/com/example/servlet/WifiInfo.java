package com.example.servlet;



public class WifiInfo {
    private String managementId;
    private String district;
    private String wifiName;
    private String roadAddress;
    private String detailedAddress;
    private Double distance;  // 거리 정보가 NULL일 수 있으므로 Double로 수정
    private String installationFloor;
    private String installationType;
    private String installationAgency;
    private String serviceType;
    private String networkType;
    private Integer installationYear;
    private String indoorOutdoor;
    private String wifiEnv;
    private double xCoordinate;
    private double yCoordinate;
    private String workDate;

    public WifiInfo(String managementId, String district, String wifiName, String roadAddress, String detailedAddress, Double distance, String installationFloor, String installationType, String installationAgency, String serviceType, String networkType, Integer installationYear, String indoorOutdoor, String wifiEnv, double xCoordinate, double yCoordinate, String workDate) {
        this.managementId = managementId;
        this.district = district;
        this.wifiName = wifiName;
        this.roadAddress = roadAddress;
        this.detailedAddress = detailedAddress;
        this.distance = distance;
        this.installationFloor = installationFloor;
        this.installationType = installationType;
        this.installationAgency = installationAgency;
        this.serviceType = serviceType;
        this.networkType = networkType;
        this.installationYear = installationYear;
        this.indoorOutdoor = indoorOutdoor;
        this.wifiEnv = wifiEnv;
        this.xCoordinate = xCoordinate;
        this.yCoordinate = yCoordinate;
        this.workDate = workDate;
    }

    public String getManagementId() {
        return managementId;
    }

    public String getDistrict() {
        return district;
    }

    public String getWifiName() {
        return wifiName;
    }

    public String getRoadAddress() {
        return roadAddress;
    }

    public String getDetailedAddress() {
        return detailedAddress;
    }

    public Double getDistance() {
        return distance;
    }

    public String getInstallationFloor() {
        return installationFloor;
    }

    public String getInstallationType() {
        return installationType;
    }

    public String getInstallationAgency() {
        return installationAgency;
    }

    public String getServiceType() {
        return serviceType;
    }

    public String getNetworkType() {
        return networkType;
    }

    public Integer getInstallationYear() {
        return installationYear;
    }

    public String getIndoorOutdoor() {
        return indoorOutdoor;
    }

    public String getWifiEnv() {
        return wifiEnv;
    }

    public double getxCoordinate() {
        return xCoordinate;
    }

    public double getyCoordinate() {
        return yCoordinate;
    }

    public String getWorkDate() {
        return workDate;
    }
}
