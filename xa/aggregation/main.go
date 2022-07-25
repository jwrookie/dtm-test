package main

import (
	"github.com/dtm-labs/client/dtmcli"
	"github.com/gin-gonic/gin"
	"github.com/go-resty/resty/v2"
	"github.com/lithammer/shortuuid/v3"
)

func main() {
	route := gin.New()

	// 测试提交
	route.GET("/testJobCommit", func(c *gin.Context) {

		// DtmServer为DTM服务的地址，是一个url
		DtmServer := "http://127.0.0.1:36789/api/dtmsvr"
		gid := shortuuid.New()
		err := dtmcli.XaGlobalTransaction(DtmServer, gid, func(xa *dtmcli.Xa) (*resty.Response, error) {
			resp, err := xa.CallBranch(nil, "http://127.0.0.1:5001/jobA")
			if err != nil {
				return resp, err
			}
			return xa.CallBranch(nil, "http://127.0.0.1:5002/jobB")
		})
		if err != nil {
			c.String(500, "%s", err.Error())
			return
		}

		c.String(200, "%s", "succ")
	})

	// 测试回滚
	route.GET("/testJobRollback", func(c *gin.Context) {

		// DtmServer为DTM服务的地址，是一个url
		DtmServer := "http://127.0.0.1:36789/api/dtmsvr"
		gid := shortuuid.New()
		err := dtmcli.XaGlobalTransaction(DtmServer, gid, func(xa *dtmcli.Xa) (*resty.Response, error) {
			resp, err := xa.CallBranch(nil, "http://127.0.0.1:5001/jobA")
			if err != nil {
				return resp, err
			}
			return xa.CallBranch(nil, "http://127.0.0.1:5002/jobBRollback")
		})
		if err != nil {
			c.String(500, "%s", err.Error())
			return
		}

		c.String(200, "%s", "succ")
	})

	if err := route.Run(":5000"); err != nil {
		panic(err)
	}
}