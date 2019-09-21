
// filename: virtinfo1.c
// Author: lufei
// Date: 20190821 16:09:25
// gcc virtinfo.c -o virtinfo -lvirt
#include<stdio.h>
#include<libvirt/libvirt.h>

 
int getDomainInfo(int id) {
    virConnectPtr conn = NULL;
    virDomainPtr dom = NULL;
    virDomainInfo info;
     
    conn = virConnectOpenReadOnly(NULL);
    if (conn == NULL) {
        fprintf(stderr, "Failed to connect to hypervisor\n");
        return 1;
    }
    dom = virDomainLookupByID(conn, id);
    if (dom == NULL) {
        fprintf(stderr, "Failed to find Domain %d\n", id);
        virConnectClose(conn);
        return 1;
    }
    if (virDomainGetInfo(dom, &info) < 0) {
        fprintf(stderr, "Failed to get information for Domain %d\n", id);
        virDomainFree(dom);
        virConnectClose(conn);
        return 1;
    }
    printf("Domain ID: %d\n", id);
    printf("    vCPUs: %d\n", info.nrVirtCpu);
    printf("    maxMem: %d KB\n", info.maxMem);
    printf("    memory: %d KB\n", info.memory);
     
    if (dom != NULL){
        virDomainFree(dom);
    }
    if (conn != NULL){
        virConnectClose(conn);
    }
    return 0;
}
int main(int argc, char **argv)
{
    int dom_id = atoi(argv[1]);
    printf("-----Get domain info by ID via libvirt C API -----\n");
    getDomainInfo(dom_id);
    return 0;
}
